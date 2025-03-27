process GLIMPSE2_CONCORDANCE {
  tag "${pair_id}"  
  publishDir path: 'GLIMPSE2_CONCORDANCE_output', mode: 'copy'  
   
  input:
    tuple val(pair_id), path(bcf), path(bcf_index)
    each  path(ref_site)
    path(ref_vcf)
  
  output:
    path("*.txt.gz")
  
  """
  echo  "${params.chr} 1000GP.${params.chr}.noNA12878.sites.vcf.gz ${params.human_genome}_GRCh38_1_22_v4.2.1_benchmark.${params.chr}.vcf.gz ${bcf}" > input_concordance.txt

  GLIMPSE2_concordance \
  --gt-val \
  --input input_concordance.txt \
  --bins 0.00000 0.001 0.01000 0.02000 0.05000 0.10000 0.20000 0.30000 0.40000 0.50000 \
  --thread 4 \
  --output ${pair_id}
   
  """
  
}

