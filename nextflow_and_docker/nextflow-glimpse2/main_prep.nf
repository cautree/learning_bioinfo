



params.target_depth = 0.5
params.chr = "chr22"

include { GLIMPSE2_CHUNK } from './modules/chunk.nf'
include { GLIMPSE2_SPLIT } from './modules/split.nf'



workflow {
  
  sites_ch = channel.fromPath("s3://seqwell-ref/vcf/1000GP." +  params.chr + ".noNA12878.sites.vcf.gz*").collect()
  chunk_ch = GLIMPSE2_CHUNK(sites_ch)

  ref_ch = channel.fromPath("s3://seqwell-ref/glimpse2/reference_panel/1000GP_" + params.chr + "_normalized.vcf.gz*").collect()
  map_ch = channel.fromPath("s3://seqwell-ref/glimpse2/gmap/" + params.chr + ".b38.gmap.gz")
  
  GLIMPSE2_SPLIT( ref_ch, map_ch, chunk_ch)
  
}
