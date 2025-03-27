process GET_C1_BCF {
  tag "${pair_id}"
  
  input:
  tuple val(pair_id), path(bcf), path(bcf_index)
  
  output:
  tuple val(pair_id), path("*.c1.sorted.vcf.gz"), path("*.c1.sorted.vcf.gz.tbi")
  
  
  """
  
  bcftools view  -c 1 -v snps $bcf > ${pair_id}.c1.vcf
  
  bcftools sort -Oz ${pair_id}.c1.vcf -o ${pair_id}.c1.sorted.vcf.gz
  
  bcftools index -t  ${pair_id}.c1.sorted.vcf.gz

  """
  
  
}
