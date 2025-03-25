process DOWNSAMPLE {
    tag "${pair_id}"

    input:
     tuple val(pair_id), path(bam)

    output:
     tuple val(pair_id), path("*.bam"), path("*.bai")

    script:
    """
    
    # Compute mean depth
    mean_depth=\$(samtools depth ${bam} | awk '{sum+=\$3; count++} END {print sum/count}')
    
    # Calculate downsampling factor
    downsample_factor=\$(awk -v target=${params.target_depth} -v mean_depth=\$mean_depth 'BEGIN {print target/mean_depth}')
    
    # Downsample BAM using calculated factor
    samtools view -b -s \$downsample_factor ${bam} > ${pair_id}.${params.target_depth}x.bam
    samtools index ${pair_id}.${params.target_depth}x.bam
    
    """
}

