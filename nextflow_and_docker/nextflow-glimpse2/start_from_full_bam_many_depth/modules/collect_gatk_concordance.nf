process COLLECT_GATK_CONCORDANCE {
  publishDir path: "gatk_concordance", mode: 'copy'    
  
  input:
    path( gatk_tsv )
  
  output:
    path("*.csv")
  
  """
  bash summarize_gatk_concordance.sh ${params.run}_${params.human_genome}_${params.chr}
  
  """
}
