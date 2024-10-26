include { dotenv } from 'plugin/nf-dotenv'

process TN_SEQ_MAKE_SUMMARY_PLOTS {
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'
    tag "${meta.sample_id}"

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 1
    memory 4.GB

    input:
    path(qc_files)

    output: 
    path("*.pdf"), emit: figures

    script:
    def datetime = new Date().format("yyyy-MM-dd_HH-mm-ss", TimeZone.getTimeZone("UTC"))
    def filename = datetime + "_tn-seq_report.pdf"
    """
    tn-seq make-summary-plots --input-dir ./ --output-pdf ${filename}
    """

    stub:
    """
    touch 2023-01-01_00_00-00-00_tn-seq_report.pdf
    """
}

process TN_SEQ_COUNT_STARTS {
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'
    tag "${meta.sample_id}"

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 2
    memory 30.GB

    input:
    tuple val(meta), path(bam), path(index)
    path(targets)

    output:
    path("${bam.getBaseName()}.insertion_counts.histogram.tsv"), emit: histogram
    path("${bam.getBaseName()}.insertion_counts.within_interval_cov.list"), emit: within_interval_cov

    script:
    def intervals = targets.name != 'NO_FILE' ? "--targets ${targets}" : ''
    """
    tn-seq count-insertion-starts \\
        --input-bam ${bam} \\
        --output-prefix "${bam.getBaseName()}.insertion_counts" \\
        --min-interval-length ${params.tn_seq.count_insertion_starts.min_interval_length} \\
        ${intervals}
    """

    stub:
    """
    touch "${bam.getBaseName()}.insertion_counts.histogram.tsv"
    touch "${bam.getBaseName()}.insertion_counts.within_interval_cov.list"
    """
}


process TN_SEQ_PLOT_INSERTION_METRICS {
    publishDir "${params.output}", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 2
    memory 8.GB

    input:
    path(histograms)
    path(within_interval_covs)

    output:
    path("*.pdf"), emit: figures

    script:
    def datetime = new Date().format("yyyy-MM-dd_HH-mm-ss", TimeZone.getTimeZone("UTC"))
    def filename = datetime + "_insertion_metrics.pdf"
    """
    tn-seq plot-insertion-metrics \\
        --input-histograms ${histograms} \\
        --input-covs ${within_interval_covs} \\
        --output-pdf ${filename}
    """

    stub:
    """
    touch 2023-01-01_00_00-00-00_insertion_metrics.pdf
    """
}
