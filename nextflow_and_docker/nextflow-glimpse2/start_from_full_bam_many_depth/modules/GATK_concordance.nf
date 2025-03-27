process GATK_CONCORDANCE {
  tag "${pair_id}"
  
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
