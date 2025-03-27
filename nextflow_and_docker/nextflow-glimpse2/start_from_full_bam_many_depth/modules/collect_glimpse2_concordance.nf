process COLLECT_GLIMPSE2_CONCORDANCE {
  publishDir path: "glimpse2_concordance", mode: 'copy'    
  
  input:
    path( glimpse2_txt)
  
  output:
    path("*.csv")
  
  """
  bash summarize_glimpse2_concordance.sh ${params.run}_${params.human_genome}_${params.chr}
  
  """
  
}
