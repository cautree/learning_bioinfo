include { dotenv } from 'plugin/nf-dotenv'

process MULTIQC {
    publishDir "${params.output}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 1
    memory 4.GB

    input:
    path(qc_files)

    output:
    path("*.html"), emit: report

    script:
    def datetime = new Date().format("yyyy-MM-dd_HH-mm-ss", TimeZone.getTimeZone("UTC"))
    def filename = datetime + "_multiqc_report.html"
    """
    # Ignore FASTQC in the general summary table because duplication rate is a poor estimate
    # Ignore mosdepth in the general summary table because bases >=30x seems incorrect
    # Ignore Picard HsMetrics in the general summary table because it is optional
    multiqc \\
        --cl-config 'table_columns_visible: { FastQC: False, mosdepth: False, "Picard: HsMetrics": False }' \\
        --cl-config 'fn_clean_exts: [".downsampled", ".duplicate_metrics", ".markdup", ".marked", ".umi-grouped"]' \\
        --filename ${filename} \\
        --force \\
        --interactive \\
        --no-data-dir \\
        --verbose \\
        ./
    """

    stub:
    """
    touch 2024-01-03_04-14-53_multiqc_report.html
    """
}
