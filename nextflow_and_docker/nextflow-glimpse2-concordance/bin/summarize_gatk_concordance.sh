#!/bin/bash


output_file="$1_GATK_concordance_report"

# Create the header for the CSV file
echo "Sample_ID,type,TP,FP,FN,RECALL,PRECISION" > "$output_file"

# Loop over each file in the directory
for file in *.tsv; do
    # Extract the sample ID from the filename (assuming the sample ID is the part before '.txt')
    sample_id=$(basename "$file" | sed 's|.ligated.c1.sorted_summary.tsv||' | sed 's|.downsampled||')

    # Process the file, add sample_id in the first column and remove INDEL row
    awk -v sample_id="$sample_id" '
        BEGIN {OFS="\t"}  # Set output field separator to tab
        $1 == "SNP" {print sample_id, $0}  # For SNP, add sample ID and print line
        $1 == "INDEL" {next}  # Skip INDEL row
    ' "$file" >> "$output_file"  # Append the result to the output CSV
done

cat "$output_file" | tr '\t' ',' > "${output_file%.csv}.csv"

# Change the file extension to .csv
#mv "$output_file" "${output_file%.csv}.csv"

