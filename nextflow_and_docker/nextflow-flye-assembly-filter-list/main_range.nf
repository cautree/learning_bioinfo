//https://github.com/sanger-pathogens/circlator/tree/master
params.downsample=500
params.run = "20250315"
params.genome_size = '10k'
params.output = 'outputs'


include { LENGTH_FILTER_RANGE } from './modules/length_filter_range.nf'
include { DOWNSAMPLE } from './modules/downsample.nf'
include { FLYE_ASSEMBLE } from './modules/flye_assemble.nf'


workflow {
  
  
    // Read length ranges from file
Channel
    .fromPath('length_ranges.tsv')
    .splitCsv(header:true, sep:'\t')
    .map { row -> tuple(row.min, row.max) }
    .set { length_ranges }

length_ranges.view()
  
    fq_ch = Channel.fromPath( "s3://seqwell-projects/20250328_pacbio_fornax/demux_output/bc20250228/merged_fastq/*.fastq.gz")
                   .map{ it-> tuple(it.baseName.tokenize(".")[0]+ it.baseName.tokenize(".")[1] , it)}
                   
  


   fq_and_ranges = fq_ch
       .combine(length_ranges)

       
    //filtered_ch = LENGTH_FILTER(fq_ch)
  
   // downsampled_fq_ch = DOWNSAMPLE(filtered_ch)
  
   // flye_ch = FLYE_ASSEMBLE(downsampled_fq_ch)
    
    
  
}

