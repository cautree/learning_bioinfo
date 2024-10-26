include { dotenv } from 'plugin/nf-dotenv'

process COLLECT_HS_METRICS {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 4
    memory 28.GB

    input:
    tuple val(meta), path(bam), path(index)
    path(fasta)
    path(fasta_index)
    path(intervals)

    output:
    path("*.txt"), emit: metrics

    when:
    intervals.name != "NO_FILE"

    script:
    def memory = (task.memory.mega * 0.8).intValue()
    """
    picard \\
        -Xmx${memory}M \\
        BedToIntervalList \\
            --INPUT ${intervals} \\
            --OUTPUT ${intervals.getBaseName()}.interval_list \\
            --SEQUENCE_DICTIONARY ${bam}

    picard \\
        -Xmx${memory}M \\
        CollectHsMetrics \\
            --INPUT ${bam} \\
            --OUTPUT ${bam.getBaseName()}.hs_metrics.txt \\
            --BAIT_INTERVALS ${intervals.getBaseName()}.interval_list \\
            --TARGET_INTERVALS ${intervals.getBaseName()}.interval_list \\
            --REFERENCE_SEQUENCE ${fasta} \\
            --PER_TARGET_COVERAGE ${bam.getBaseName()}.hs_metrics.per_target.txt \\
            --CLIP_OVERLAPPING_READS true \\
            --INCLUDE_INDELS true
    """

    stub:
    """
    touch TEST-SAMPLE.marked.hs_metrics.txt
    touch TEST-SAMPLE.marked.hs_metrics.per_target.txt
    """
}

process COLLECT_MULTIPLE_METRICS {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 8
    memory 30.GB

    input:
    tuple val(meta), path(bam), path(index)
    path(fasta)
    path(fasta_index)
    path(targets)

    output:
    path("*.txt"), emit: metrics
    path("*.pdf"), emit: figures

    script:
    def memory = (task.memory.mega * 0.8).intValue()
    def intervals = targets.name != 'NO_FILE' ? "--INTERVALS ${targets.getBaseName()}.interval_list" : ''
    """
    [ -z "${intervals}" ] || picard \\
        -Xmx${memory}M \\
        BedToIntervalList \\
            --INPUT ${targets} \\
            --OUTPUT ${targets.getBaseName()}.interval_list \\
            --SEQUENCE_DICTIONARY ${bam}

    picard \\
        -Xmx${memory}M \\
        CollectMultipleMetrics \\
            --VALIDATION_STRINGENCY SILENT \\
            --INPUT ${bam} \\
            --OUTPUT ${bam.getBaseName()} \\
            --REFERENCE_SEQUENCE ${fasta} \\
            --FILE_EXTENSION .txt \\
            --PROGRAM null \\
            --PROGRAM CollectAlignmentSummaryMetrics \\
            --PROGRAM CollectBaseDistributionByCycle \\
            --PROGRAM CollectGcBiasMetrics \\
            --PROGRAM CollectInsertSizeMetrics \\
            --PROGRAM CollectQualityYieldMetrics \\
            --PROGRAM MeanQualityByCycle \\
            --PROGRAM QualityScoreDistribution \\
            ${intervals}
    """

    stub:
    """
    touch TEST-SAMPLE.marked.alignment_summary_metrics.txt
    touch TEST-SAMPLE.marked.base_distribution_by_cycle_metrics.txt
    touch TEST-SAMPLE.marked.gc_bias.detail_metrics.txt
    touch TEST-SAMPLE.marked.gc_bias.pdf
    touch TEST-SAMPLE.marked.gc_bias.summary_metrics.txt
    touch TEST-SAMPLE.marked.quality_by_cycle_metrics.txt
    touch TEST-SAMPLE.marked.quality_distribution_metrics.txt
    touch TEST-SAMPLE.marked.quality_yield_metrics.txt
    """
}

process COLLECT_WGS_METRICS {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 8
    memory 30.GB

    input:
    tuple val(meta), path(bam), path(index)
    path(fasta)
    path(fasta_index)
    path(targets)

    output: 
    path("*.txt"), emit: metrics

    script:
    def memory = (task.memory.mega * 0.8).intValue()
    def intervals = targets.name != 'NO_FILE' ? "--INTERVALS ${targets.getBaseName()}.interval_list" : ''
    """
    [ -z "${intervals}" ] || picard \\
        -Xmx${memory}M \\
        BedToIntervalList \\
            --INPUT ${targets} \\
            --OUTPUT ${targets.getBaseName()}.interval_list \\
            --SEQUENCE_DICTIONARY ${bam}

    picard \\
        -Xmx${memory}M \\
        CollectWgsMetrics \\
            --VALIDATION_STRINGENCY SILENT \\
            --INPUT ${bam} \\
            --OUTPUT ${bam.getBaseName()}.wgs_metrics.txt \\
            --REFERENCE_SEQUENCE ${fasta} \\
            --USE_FAST_ALGORITHM true \\
            ${intervals}
    """

    stub:
    """
    touch TEST-SAMPLE.marked.wgs_metrics.txt
    """
}

process POSITION_BASED_DOWNSAMPLE_SAM {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 8
    memory 30.GB

    input:
    tuple val(meta), path(bam)

    output: 
    tuple val(meta), path("*.bam"), emit: bam

    script:
    def memory = (task.memory.mega * 0.8).intValue()
    """
    picard \\
        -Xmx${memory}M \\
        PositionBasedDownsampleSam \\
            --INPUT ${bam} \\
            --OUTPUT ${bam.getBaseName()}.downsampled.bam \\
            --FRACTION ${meta.downsample_fraction}
    """

    stub:
    """
    touch TEST-SAMPLE.downsampled.bam
    """
}
