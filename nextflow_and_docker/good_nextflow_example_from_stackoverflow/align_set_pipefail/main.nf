process mapping {
    
    conda 'envs/bwa.yml'
    publishDir 'results/mapped', mode: 'copy'
  
    input:
    tuple val(sample_id), path(fastq)
    path bwa_index

    output:
    tuple val(sample_id), path("${sample_id}.bam")

    script:
    def idxbase = bwa_index[0].baseName

    """
    bwa mem "${idxbase}" "${fastq}" | samtools view -b - > "${sample_id}.bam"
    """

}

workflow {

    fastq_data = channel.fromPath( 'data/samples/*.fastq' ).map { file ->
        tuple(file.baseName, file)
    }

    bwa_index = file( 'data/genome.fa.{,amb,ann,bwt,pac,sa}' )

    mapping( fastq_data, bwa_index )
}