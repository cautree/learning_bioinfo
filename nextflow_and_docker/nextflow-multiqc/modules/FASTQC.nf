include { dotenv } from 'plugin/nf-dotenv'

process FASTQC {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus { Math.min(12, fastqs.size()) }
    memory 16.GB

    input:
    tuple val(meta), path(fastqs)

    output:
    path("*.html"), emit: reports
    path("*.zip"), emit: metrics

    script:
    """
    fastqc --threads ${task.cpus} ${fastqs}
    """

    stub:
    """
    touch TEST-SAMPLE.R1_fastqc.html
    touch TEST-SAMPLE.R1_fastqc.zip
    touch TEST-SAMPLE.R2_fastqc.html
    touch TEST-SAMPLE.R2_fastqc.zip
    """
}
