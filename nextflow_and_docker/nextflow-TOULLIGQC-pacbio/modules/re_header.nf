

process RE_HEADER {
    input:
    tuple val(pair_id), path(read)

    output:
    tuple val(pair_id), path("${pair_id}_fixed.bam")

    script:
    """
    # Step 1: Extract the BAM header
    samtools view -H $read > header.sam

    # Step 2: Remove the @RG line from the header file
    grep -v '^@RG' header.sam > new_header.sam

    # Step 3: Apply the modified header to the BAM file
    samtools reheader new_header.sam $read > ${pair_id}_fixed.bam

    """
}
