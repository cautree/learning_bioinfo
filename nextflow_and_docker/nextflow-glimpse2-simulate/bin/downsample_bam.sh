#!/bin/bash

set -e

SAMPLE_ID=$1
BAM=$2
INDEX=$3
TARGET_COVERAGES=$4




# Compute original coverage
ORIGINAL_COVERAGE=$(samtools depth $BAM | \
  awk '{sum+=$3; count++} END {print  sum/count}')

echo "Original Coverage: $ORIGINAL_COVERAGE"

# Loop over each target coverage
for target_coverage in ${TARGET_COVERAGES//,/ }; do
    echo "Processing target coverage: $target_coverage"

    # Compute downsampling fraction
    if (( $(echo "$ORIGINAL_COVERAGE <= $target_coverage" | bc -l) )); then
        echo "BAM is already at or below $target_coverage x coverage. Copying as is."
        cp "$BAM" "${SAMPLE_ID}.${target_coverage}x.downsampled.bam"
    else
        FRACTION=$(echo "scale=6; $target_coverage / $ORIGINAL_COVERAGE" | bc)
        echo "Downsampling fraction: $FRACTION"

        # Downsample BAM
        samtools view -s "$FRACTION" -b "$BAM" > "${SAMPLE_ID}.${target_coverage}x.downsampled.bam"
    fi

    # Index the downsampled BAM
    samtools index "${SAMPLE_ID}.${target_coverage}x.downsampled.bam"
    echo "done index ${SAMPLE_ID}"
done

