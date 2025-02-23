
params.run = "20250117_NextSeq2000"

process vcf_sample_name_change {
  
  input:
  path(vcf)
  
  output:
  path("*vcf.gz")
  
  """
  
  echo  HG001 > samples.txt

  ls | grep vcf.gz | grep -v tbi > file
  
  while read line; do
    bcftools reheader -s samples.txt -o a.vcf.gz \$line
    mv a.vcf.gz renamed.\$line
    bcftools index  renamed.\$line
  done < file
  rm file
  
  """
}

process glimpse2_concordance {
  
  debug true
  publishDir path: "glimpse2_concordance", mode: 'copy'
    
  input:
   path(vcf)
  path(ref_site)
  path(ref_vcf)
  
  output:
  path("*.txt.gz")
  
  
  
  """
  
  ls |  grep vcf.gz | grep -v csi |  grep -v chr22 |  wc -l > count
  
  n=\$(cat count)
  yes "chr22 1000GP.chr22.noNA12878.sites.vcf.gz HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz" | head -n \$n >> reference.txt

  ls |  grep vcf.gz | grep -v tbi |  grep -v chr22  > vcf_file.txt

  paste reference.txt vcf_file.txt > files
  cat vcf_file.txt  | cut -d. -f2 | sed 's|^|,|' > name
  paste files name > info

  while read line; do 
    part1=\$(echo \$line | cut -d, -f1)
    part2=\$(echo \$line | cut -d, -f2)
    echo \${part1} > input_concordance.txt
    echo \${part2} > for_check

  GLIMPSE2_concordance_static \
  --gt-val \
  --input input_concordance.txt \
  --bins 0.00000 0.001 0.01000 0.02000 0.05000 0.10000 0.20000 0.30000 0.40000 0.50000 \
  --thread 4 \
  --output \${part2}.concordance_c20_rp140

 done < info
   
   
  """
  
}


process get_c1_vcf {
  
  input:
  path(vcf)
  
  output:
  path("*.c1.sorted.vcf.gz*")
  
  
  """
  
  ls | grep .vcf.gz| grep -v tbi |  sed 's|.vcf.gz||g' > file
  
  while read line; do 
  bcftools view  -c 1 -v snps \${line}.vcf.gz > \${line}.c1.vcf
  done < file
  
  rm file 
  
  

  ls | grep .c1.vcf | sed 's|.c1.vcf||g' > c1_file
  while read line; do
  bcftools sort -Oz \${line}.c1.vcf -o \${line}.c1.sorted.vcf.gz
  
  bcftools index  \${line}.c1.sorted.vcf.gz
  done < c1_file
  
  rm c1_file
  
  """
  
  
}


process gatk_index {
  
  input:
  path(vcf)
  
  
  output:
  path("*tbi")
  
  
  """
  
  ls | grep c1.sorted.vcf.gz | grep -v csi  > c1_file
  while read line; do
  
  gatk IndexFeatureFile \
   -I \${line}
 
  done < c1_file
  
  rm c1_file
  
  
  """
  
  
}



//s3://seqwell-ref/chr22.fa
//s3://seqwell-ref/chr22.fa.fai
//s3://seqwell-ref/chr22.dict


process gatk_concordance {
  publishDir path: "gatk_concordance", mode: 'copy'  
  input:
  tuple path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6), path(ref7), path(ref8)
  tuple path(truth_vcf), path(truth_vcf_index), path(truth_vcf_index2) 
  tuple val(pair_id), path(eval), path( eval_index ),  path( eval_index2)
  
  
  output:
  path("*summary.tsv")
  
  
  """
  gatk Concordance \
   -R $ref2 \
   -eval $eval \
   --truth ${truth_vcf} \
   --summary ${pair_id}_summary.tsv

  """
  
  
}




workflow {
  
   vcf_ch = Channel.fromPath("s3://seqwell-analysis/20250117_NextSeq2000/glimpse2/impute/imputation/glimpse2/samples/*.vcf.gz*").collect()
 // vcf_ch = Channel.fromPath("vcf/*.vcf.gz*").collect()  

  vcf_new_sample_name_all = vcf_sample_name_change(vcf_ch)
  vcf_new_sample_name_all.view() 
  
  ref_sites_ch = Channel.fromPath("s3://seqwell-ref/vcf/1000GP.chr22.noNA12878.sites.vcf.gz")
  
  ref_ch = Channel.fromPath("s3://seqwell-ref/vcf/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz*").collect()
   ref_ch2 = Channel.fromPath("s3://seqwell-ref/vcf2/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz*").collect()
  glimpse2_concordance(vcf_new_sample_name_all, ref_sites_ch, ref_ch2)
  
  vcf_c1_ch = get_c1_vcf(vcf_ch)
  
  vcf_index_ch_0 = gatk_index(vcf_c1_ch)
  vcf_index_ch = vcf_index_ch_0.collect().flatten()
                 .map{ it -> tuple ( it.baseName.tokenize(".")[0], it)}
  
  
  vcf_c1_index_ch = vcf_c1_ch.collect().flatten()
                   .map{ it -> tuple ( it.baseName.tokenize(".")[0], it)}
                   .groupTuple()
                   .map{ it -> tuple ( it[0], it[1][0], it[1][1] )}
                   .join( vcf_index_ch)

   
   REFGEN_ch = Channel.fromPath("s3://seqwell-ref/chr22*").collect()
     REFGEN_ch.view()
   truth_vcf_ch = Channel.fromPath("s3://seqwell-ref/vcf/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz*").collect()
   truth_vcf_ch.view()
   gatk_concordance( REFGEN_ch, truth_vcf_ch, vcf_c1_index_ch )

}
