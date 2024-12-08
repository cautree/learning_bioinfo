params.reads = '/Users/name/Downloads/tiny/normal/*_R{1,2}_xxx.fastq.gz'
params.hg38genome = '/Users/name/Downloads/NM.fasta'

include { bwa_index } from './bwa.nf'
include { bwa_mem } from './bwa.nf'


workflow {

    reads = Channel.fromFilePairs( params.reads )

    hg38genome = file( params.hg38genome )

    bwa_index( hg38genome, hg38genome.name )
    bwa_mem( reads, bwa_index.out )

    bwa_mem.out.view()
}