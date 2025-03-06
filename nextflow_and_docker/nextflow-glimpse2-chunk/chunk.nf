

params.chrom = "chr22"
sites_ch = channel.fromPath("s3://seqwell-ref/vcf/1000GP." +  params.chrom + ".noNA12878.sites.vcf.gz*").collect()

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
--region ${params.chrom} \
--sequential  \
--output chunks.${params.chrom}.txt
  
  
  """
  
  
}


workflow {
  
  
  GLIMPSE2_chunk(sites_ch)
}