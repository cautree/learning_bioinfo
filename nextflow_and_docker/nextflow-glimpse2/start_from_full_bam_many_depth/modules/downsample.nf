process DOWNSAMPLE {
    tag "${pair_id}_${target_depth}x"

    input:
    tuple val(pair_id), path(bam), path(bam_index), val(target_depth)

    output:
    tuple val("${pair_id}.${target_depth}x"), path("*.bam"), path("*.bai")

    script:
    """
    # Compute mean depth
    mean_depth=\$(samtools depth ${bam} | awk '{sum+=\$3; count++} END {print sum/count}')
    
    # Calculate downsampling factor
    downsample_factor=\$(awk -v target=${target_depth} -v mean_depth=\$mean_depth 'BEGIN {print target/mean_depth}')
    
    # Downsample BAM using calculated factor
    samtools view -b -s \$downsample_factor ${bam} > ${pair_id}.${target_depth}x.bam
    samtools index ${pair_id}.${target_depth}x.bam
    """
}
