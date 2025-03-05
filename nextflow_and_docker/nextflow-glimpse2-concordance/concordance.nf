
params.run = "20241213_NextSeq2000"
params.human_genome = "HG001"


process vcf_sample_name_change {
  
  input:
  path(vcf)
  
  output:
  path("*vcf.gz")
  
  """
  
  echo  ${params.human_genome} > samples.txt

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
  
//  debug true
  //publishDir path: "glimpse2_concordance", mode: 'copy'
  publishDir path: "s3://seqwell-users/yanyan/glimpse2-impute/${params.run}/${params.human_genome}/glimpse2_concordance", mode: 'copy' 
    
  input:
  path(vcf)
  path(ref_site)
  path(ref_vcf)
  
  output:
  path("*.txt.gz")
  
  
  
  """
  
  ls |  grep vcf.gz | grep -v csi |  grep -v chr22 |  wc -l > count
  
  n=\$(cat count)
  yes "chr22 1000GP.chr22.noNA12878.sites.vcf.gz ${params.human_genome}_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz" | head -n \$n >> reference.txt

  ls |  grep vcf.gz | grep -v tbi |  grep -v chr22  > vcf_file.txt

  paste reference.txt vcf_file.txt > files
  cat vcf_file.txt  | cut -d. -f2- | sed 's|.downsampled.ligated.vcf.gz||' |  sed 's|.ligated.vcf.gz||' |  sed 's|^|,|' > name
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
  //debug true
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
  
  bcftools index -t  \${line}.c1.sorted.vcf.gz
  done < c1_file
  
  rm c1_file
  
  """
  
  
}




process gatk_concordance {
  //debug true
  //publishDir path: "gatk_concordance", mode: 'copy'  
  publishDir path: "s3://seqwell-users/yanyan/glimpse2-impute/${params.run}/${params.human_genome}/gatk_concordance", mode: 'copy' 
  
  
  input:
  tuple path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6), path(ref7), path(ref8)
  tuple path(truth_vcf), path(truth_vcf_index), path(truth_vcf_index2) 
  tuple val(pair_id), path(eval), path( eval_index )
  
  
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

process collect_gatk_concordance {
  
  //publishDir path: "gatk_concordance_summary", mode: 'copy' 
  publishDir path: "s3://seqwell-users/yanyan/glimpse2-impute/${params.run}/report/", mode: 'copy' 
  
  
  input:
  path( gatk_tsv)
  
  output:
  path("*.csv")
  
  
  """
  bash summarize_gatk_concordance.sh ${params.run}_${params.human_genome}
  
  """
  
}

process collect_glimpse2_concordance {
  
  //publishDir path: "glimpse2_concordance_summary", mode: 'copy'
  publishDir path: "s3://seqwell-users/yanyan/glimpse2-impute/${params.run}/report/", mode: 'copy' 
  
  input:
  path( glimpse2_txt)
  
  output:
  path("*.csv")
  
  
  """
  bash summarize_glimpse2_concordance.sh ${params.run}_${params.human_genome}
  
  """
  
}

workflow {

  
  ref_sites_ch = Channel.fromPath("s3://seqwell-ref/vcf/1000GP.chr22.noNA12878.sites.vcf.gz")
  REFGEN_ch = Channel.fromPath("s3://seqwell-ref/chr22*").collect()

 //vcf_ch = Channel.fromPath("s3://seqwell-users/yanyan/glimpse2-impute/20241213_NextSeq2000/na12878/*.vcf.gz*").collect() 
  vcf_ch = Channel.fromPath("s3://seqwell-users/yanyan/glimpse2-impute/" + params.run + "/" + params.human_genome + "/*.vcf.gz*").collect() 

  vcf_new_sample_name_all = vcf_sample_name_change(vcf_ch)
 
  
  //vcf folder with both csi tbi index
  truth_vcf_ch = Channel.fromPath("s3://seqwell-ref/vcf/" + params.human_genome + "_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz*").collect()
  //no tbi
  truth_vcf_ch2 = Channel.fromPath("s3://seqwell-ref/vcf/"+ params.human_genome + "_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz{,.csi}").collect()

  
  glimpse2_concordance_out =  glimpse2_concordance(vcf_new_sample_name_all, ref_sites_ch, truth_vcf_ch2)
  
  vcf_c1_ch = get_c1_vcf(vcf_ch)
    vcf_c1_ch.view()  
    vcf_c1_index_ch = vcf_c1_ch.flatten()
                    .map { it -> 
        def pair_id = it.baseName.replace('.vcf.gz', '').replace('.vcf', '')
        tuple(pair_id,  it)
    }
    .groupTuple()
    .map { it -> tuple( it[0], it[1][0], it[1][1])}

 
   gatk_concordance_out =  gatk_concordance( REFGEN_ch, truth_vcf_ch, vcf_c1_index_ch )
   collect_gatk_concordance(gatk_concordance_out.collect())
   collect_glimpse2_concordance(glimpse2_concordance_out.collect())
}
