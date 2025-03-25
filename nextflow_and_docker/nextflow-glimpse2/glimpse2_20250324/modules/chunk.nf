process GLIMPSE2_CHUNK {
  publishDir path: 'output', mode: 'copy'  
  
  input:
    path(sites)
  
  output:
   path("*.txt")
  
  """
  
    GLIMPSE2_chunk \
  --input $sites \
  --region ${params.chr} \
  --sequential  \
  --output chunks.${params.chr}.txt
  
  """
  
}
