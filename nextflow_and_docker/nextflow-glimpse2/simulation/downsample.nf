nextflow.enable.dsl=2

params.target_depth = 0.5

process COMPUTE_AND_DOWNSAMPLE {
    tag "${pair_id}"

    input:
    tuple val(pair_id), path(bam)

    output:
    tuple val(pair_id), path("*.bam")

    script:
    """
    # Compute mean depth
    mean_depth=\$(samtools depth ${bam} | awk '{sum+=\$3; count++} END {print sum/count}')
    
    # Calculate downsampling factor
    downsample_factor=\$(awk -v target=${params.target_depth} -v mean_depth=\$mean_depth 'BEGIN {print target/mean_depth}')
    
    # Downsample BAM using calculated factor
    samtools view -b -s \$downsample_factor ${bam} > ${pair_id}.${params.target_depth}x.bam
    """
}

workflow  {
    ch_bam = channel
            .fromPath("bam/*.bam")
            .map { it -> tuple(it.baseName.tokenize(".")[0], it) }
    
    COMPUTE_AND_DOWNSAMPLE(ch_bam)
}
