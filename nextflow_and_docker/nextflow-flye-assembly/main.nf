
//https://github.com/sanger-pathogens/circlator/tree/master
params.downsample=500
params.run = "20250315"
params.genome_size = '8k'

include { DOWNSAMPLE } from './modules/downsample.nf'
include { FLYE_ASSEMBLE } from './modules/flye_assemble.nf'
include { MINIMAP2 } from './modules/minimap2.nf'
include { SUMMARIZE } from './modules/summarize.nf'

include { CIRCULARIZE} from './modules/circularize.nf'
include { BAM_READ_COUNT } from './modules/bam_read_count.nf'
include { PLANNOTATE } from './modules/plannotate.nf'
include { FIX_START } from './modules/fix_start.nf'
include { ANALYZE_BAM_READ_COUNT } from './modules/analyze_bam_read_count.nf'
include { PLASMIDMAP } from './modules/plasmidMap.nf'
include { CIRCLATOR_MINIMUS2 } from './modules/circlator_minimus2.nf'




workflow {
  
    fq_ch = Channel.fromPath( "s3://seqwell-users/yanyan/minION/fastq/*.fastq.gz")
                   .map{ it-> tuple(it.baseName.tokenize(".")[0] , it)}
                   .take(10)
  
    downsampled_fq_ch = DOWNSAMPLE(fq_ch)
  
    flye_ch = FLYE_ASSEMBLE(downsampled_fq_ch)
  
    
    
    circle_ch = CIRCLATOR_MINIMUS2(flye_ch.flye_fasta)
    
    align_in = fq_ch.join(circle_ch.fasta)
  
    minimap2_ch = MINIMAP2(align_in)
  
    bam_read_count_report = BAM_READ_COUNT(minimap2_ch.bam.join(circle_ch.fasta))
    
    metrics_out = minimap2_ch.metrics.mix(circle_ch.csv)
//    metrics_out.view()  
                  
    
    SUMMARIZE(metrics_out.collect())
    
    fix_start_out = FIX_START(circle_ch.fasta)
    
    gbk = PLANNOTATE(fix_start_out)

    PLASMIDMAP(gbk.collect())
    
    ANALYZE_BAM_READ_COUNT(bam_read_count_report)
  
  
  
  
}


//flye --nano-raw ${fq} -g ${params.genome_size}   --asm-coverage 50 --out-dir data  
//flye --pacbio-hifi ${fq} -g ${params.genome_size}   --asm-coverage 50 --out-dir data 



