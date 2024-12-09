nextflow.enable.dsl=2

params.ref_fasta = "GRCh38.primary_assembly.genome.chr22.fa.gz"
params.fastq_files = "data/*/*.read{1,2}.fastq.gz"


process bwa_index {

    conda 'bwa-mem2'

    input:
    path fasta

    output:
    path "${fasta}.{0123,amb,ann,bwt.2bit.64,pac}"

    """
    bwa-mem2 index "${fasta}"
    """
}


process bwa_mem2 {

    tag { [sample, readgroup].join(':') }

    conda 'bwa-mem2 samtools'

    input:
    tuple val(sample), val(readgroup), path(reads)
    path bwa_index

    output:
    tuple val(sample), val(readgroup), path("${readgroup}.bam{,.bai}")

    script:
    def idxbase = bwa_index.first().baseName   //use first to get the first from a list
    //https://github.com/samtools/samtools/issues/1568, ##idx## to control index type
    def out_files = [ "${readgroup}.bam", "${readgroup}.bam.bai" ].join('##idx##')
    def (r1, r2) = reads

    """
    bwa-mem2 mem \\
        -R '@RG\\tID:${readgroup}\\tSM:${sample}' \\
        -t ${task.cpus} \\
        "${idxbase}" \\
        "${r1}" \\
        "${r2}" |
    samtools sort \\
        --write-index \\
        -@ ${task.cpus} \\
        -o "${out_files}"
    """
}


process samtools_merge {

    tag { sample }

    conda 'samtools'

    input:
    tuple val(sample), path(indexed_bam_files)

    output:
    tuple val(sample), path("${sample}.bam{,.bai}")

    script:
    def out_files = [ "${sample}.bam", "${sample}.bam.bai" ].join('##idx##')
    def input_bam_files = indexed_bam_files
        .findAll { it.name.endsWith('.bam') }
        .collect { /"${it}"/ }
        .join(' \\\n'+' '*8)     //each input bam file occupy a line in the command below

    """
    samtools merge \\
        --write-index \\
        -o "${out_files}" \\
        ${input_bam_files}
    """
}


workflow {

    ref_fasta = file( params.ref_fasta )
    bwa_index( ref_fasta )

    Channel.fromFilePairs( params.fastq_files ) \
        | map { readgroup, reads ->
            def (sample_name) = reads*.parent.baseName as Set

            tuple( sample_name, readgroup, reads )
        } \
        | groupTuple() \
        | map { sample, readgroups, reads ->
            tuple( groupKey(sample, readgroups.size()), readgroups, reads )
        } \
        | transpose() \
        | set { sample_readgroups }

    bwa_mem2( sample_readgroups, bwa_index.out )

    sample_readgroups \
        | join( bwa_mem2.out, by: [0,1] ) \
        | map { sample_key, readgroup, reads, indexed_bam ->
            tuple( sample_key, indexed_bam )
        } \
        | groupTuple() \
        | map { sample_key, indexed_bam_files ->
            tuple( sample_key.toString(), indexed_bam_files.flatten() )
        } \
        | samtools_merge
}


//https://stackoverflow.com/questions/69702077/nextflow-how-to-process-multiple-samples