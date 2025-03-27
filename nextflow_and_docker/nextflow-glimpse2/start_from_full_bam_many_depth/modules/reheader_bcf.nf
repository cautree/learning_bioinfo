process BCF_REHEADER {
  tag "${pair_id}"
  
  input:
    tuple val(pair_id), path(bcf), path(bcf_index)
  
  output:
    tuple val(pair_id), path("*reheader*.bcf"), path("*reheader*.bcf.csi")
  
  """
  
  echo  ${params.human_genome} > samples.txt
  bcftools reheader -s samples.txt -o reheader.${pair_id}.bcf $bcf
  bcftools index  reheader.${pair_id}.bcf
  
  """
}
