include { dotenv } from 'plugin/nf-dotenv'

process MOSDEPTH {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 6
    memory 10.GB

    input:
    tuple val(meta), path(bam), path(index)
    path(targets)

    output: 
    path("*.bed.gz"), emit: beds
    path("*.mosdepth.*.txt"), emit: metrics

    script:
    def intervals = targets.name != 'NO_FILE' ? targets : params.mosdepth.coverage_bin_width
    """
    mosdepth \\
        --threads ${task.cpus} \\
        --by ${intervals} \\
        --thresholds ${params.mosdepth.coverage_thresholds} \\
        ${bam.getBaseName()} \\
        ${bam}
    """

    stub:
    """
    touch TEST-SAMPLE.marked.mosdepth.global.dist.txt
    touch TEST-SAMPLE.marked.mosdepth.region.dist.txt
    touch TEST-SAMPLE.marked.mosdepth.summary.txt
    touch TEST-SAMPLE.marked.per-base.bed.gz
    touch TEST-SAMPLE.marked.regions.bed.gz
    touch TEST-SAMPLE.marked.thresholds.bed.gz
    """
}
