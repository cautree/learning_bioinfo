#!/bin/bash

# Define S3 base paths for BAM and FASTQ
S3_BAM_BASE_PATH="s3://seqwell-analysis"
S3_FASTQ_BASE_PATH="s3://seqwell-fastq"

# Get START_DATE and END_DATE as parameters (default to specific dates if not provided)
START_DATE="${1:-20240801}"
END_DATE="${2:-20240931}"

# File extensions to target
BAM_EXTENSIONS=("bam" "bai")
FASTQ_EXTENSION="fastq.gz"

# Validate date format (YYYYMMDD)
if [[ ! "$START_DATE" =~ ^[0-9]{8}$ || ! "$END_DATE" =~ ^[0-9]{8}$ ]]; then
    echo "Error: Invalid date format. Please provide dates in YYYYMMDD format."
    exit 1
fi

# Find matching BAM paths (in seqwell-analysis)
echo "Finding matching BAM paths within $S3_BAM_BASE_PATH for date range $START_DATE to $END_DATE..."

# Get the prefix for dates
START_PREFIX="${START_DATE:0:6}"
END_PREFIX="${END_DATE:0:6}"

MATCHING_BAM_PATHS=$(aws s3 ls "$S3_BAM_BASE_PATH/" | awk '{print $2}' | grep -E "(${START_PREFIX}[0-9]{2}|${END_PREFIX}[0-9]{2})")

# Perform dry run for BAM files
echo "Performing dry run for BAM files to check files that would be modified..."
for path in $MATCHING_BAM_PATHS; do
    FULL_PATH="$S3_BAM_BASE_PATH/$path"
    
    for ext in "${BAM_EXTENSIONS[@]}"; do
        aws s3 cp "$FULL_PATH" "$FULL_PATH" --recursive \
            --storage-class DEEP_ARCHIVE \
            --exclude "*" --include "*.$ext" \
            --dryrun
    done
done

echo "Dry run for BAM files completed."

# Find matching FASTQ paths (in seqwell-fastq)
echo "Finding matching FASTQ paths within $S3_FASTQ_BASE_PATH for date range $START_DATE to $END_DATE..."

MATCHING_FASTQ_PATHS=$(aws s3 ls "$S3_FASTQ_BASE_PATH/" | awk '{print $2}' | grep -E "(${START_PREFIX}[0-9]{2}|${END_PREFIX}[0-9]{2})")

# Perform dry run for FASTQ files inside directories
echo "Performing dry run for FASTQ files inside directories..."
for path in $MATCHING_FASTQ_PATHS; do
    FULL_PATH="$S3_FASTQ_BASE_PATH/$path"
    
    aws s3 cp "$FULL_PATH" "$FULL_PATH" --recursive \
        --storage-class DEEP_ARCHIVE \
        --exclude "*" --include "*.$FASTQ_EXTENSION" \
        --dryrun
done

# Handle standalone FASTQ files (e.g., Undetermined_S0_R1_001.fastq.gz) with strict date filtering
echo "Performing dry run for standalone FASTQ files (e.g., Undetermined_S0_R1_001.fastq.gz) within date range..."

# Find files matching the date range in the path (for "Undetermined_S0_R1_001.fastq.gz")
MATCHING_UNDETERMINED_FASTQ=$(aws s3 ls "$S3_FASTQ_BASE_PATH/" | awk '{print $2}' | grep -E "(${START_PREFIX}[0-9]{2}|${END_PREFIX}[0-9]{2})" | grep "Undetermined_S0_R1_001.fastq.gz")

for path in $MATCHING_UNDETERMINED_FASTQ; do
    FULL_PATH="$S3_FASTQ_BASE_PATH/$path"
    
    aws s3 cp "$FULL_PATH" "$FULL_PATH" --recursive \
        --storage-class DEEP_ARCHIVE \
        --exclude "*" --include "*Undetermined_S0_R1_001.fastq.gz" \
        --dryrun
done

echo "Dry run for standalone FASTQ files completed."

echo "Dry run completed. If everything looks good, remove --dryrun and rerun the script."
