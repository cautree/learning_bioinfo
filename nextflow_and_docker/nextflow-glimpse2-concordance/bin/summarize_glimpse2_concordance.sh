#!/bin/bash



# Output CSV file
output_file="$1_glimpse2_summary_report.csv"



# Create the header for the CSV file
echo "Sample_ID,MAF_group,SNP_count,MAF,genotype_rate,r_squared" > "$output_file"

# Loop through each gzipped file in the directory
for file in *.rsquare.grp.txt.gz; do
    # Extract the sample ID from the filename (assuming the sample ID is the part before '.concordance')
    sample_id=$(basename "$file" | sed 's|.concordance_c20_rp140.rsquare.grp.txt.gz||')

    # Process the gzipped file, add sample_id in the first column
    zcat "$file" | awk -v sample_id="$sample_id" 'BEGIN {OFS=","} 
        {print sample_id, $1, $2, $3, $4, $5}' >> "$output_file"
done

# Final output message
echo "CSV report generated: $output_file"

