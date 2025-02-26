
sites_ch = channel.fromPath("1000GP.chr22.noNA12878.sites.vcf.gz*").collect()


process GLIMPSE2_chunk {
  
  publishDir path: "chunk",  mode: 'copy'
  
  container "glimpse:v2.0.0-27-g0919952_20221207"
  
  input:
  path(sites)
  
  output:
  path("*")
  
  """
  
  GLIMPSE2_chunk \
--input $sites \
--region chr22 \
--sequential  \
--output chunks.chr22.txt
  
  
  """
  
  
}


workflow {
  
  
  GLIMPSE2_chunk(sites_ch)
}