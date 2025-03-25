params.target_depth = 0.5
params.chr = "chr22"

include { DOWNSAMPLE } from './modules/downsample.nf'
include { GLIMPSE2_PHASE } from './modules/phase.nf'
include { GLIMPSE2_LIGATE } from './modules/ligate.nf'
include { BCF_INDEX } from './modules/index_bcf.nf'

workflow {
  
   bam_ch = Channel.fromPath("bam/*.bam")
                   .map{ it-> tuple(it.baseName.tokenize(".")[0], it)}
                   
   downsampled_bam = DOWNSAMPLE( bam_ch )
   
   split_genome_ch =Channel.fromPath("output/1000GP." + params.chr + "*.bin").collect()
  
   chunk_file_ch = Channel.fromPath("output/chunks." +  params.chr + ".txt")
  
   bcf = GLIMPSE2_PHASE(downsampled_bam, split_genome_ch, chunk_file_ch)
  
   ligated_bcf = GLIMPSE2_LIGATE(bcf)  
}

