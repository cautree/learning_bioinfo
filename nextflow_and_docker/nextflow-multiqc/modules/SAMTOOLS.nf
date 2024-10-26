include { dotenv } from 'plugin/nf-dotenv'

process MARK_DUPLICATES {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 50
    memory { 240.GB * task.attempt }
    errorStrategy { task.exitStatus in ((130..145) + 104) ? 'retry' : 'terminate' }
    maxRetries 2

    input:
    tuple val(meta), path(bam)
    path(fasta)

    output: 
    tuple val(meta), path("*.bam"), path("*.bai"), emit: bam_and_index
    path("*.tsv"), emit: metrics

    script:
    def barcode_arg = null == meta.umi_fastq ? "" : "--barcode-tag MI"
    """
    samtools sort \\
        -u \\
        --threads ${task.cpus} \\
        --reference "${fasta}" \\
        "${bam}" \\
    | samtools markdup \\
        -d ${params.samtools.markdup.duplicate_distance} \\
        -f ${bam.getBaseName()}.marked.duplicate_metrics.tsv \\
        -S \\
        --mode t \\
        --threads ${task.cpus} \\
        ${barcode_arg} \\
        - \\
        ${bam.getBaseName()}.marked.bam

    samtools index \\
        --threads ${task.cpus} \\
        --bai \\
        --output ${bam.getBaseName()}.marked.bam.bai \\
        ${bam.getBaseName()}.marked.bam
    """

    stub:
    """
    touch TEST-SAMPLE.marked.bam
    touch TEST-SAMPLE.marked.bam.bai
    touch TEST-SAMPLE.marked.duplicate_metrics.tsv
    """
}
