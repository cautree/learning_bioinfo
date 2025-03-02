


aws s3 ls s3://seqwell-fastq/20250115_NextSeq2000/A2001_clean_FASTQ/ | cut -32 - > file

cat file | grep R1 > left
cat file | grep R2 > right

while read line; do 

echo s3://seqwell-fastq/20250115_NextSeq2000/A2001_clean_FASTQ/$line >> fq_1_file

done < left 

while read line; do 

echo s3://seqwell-fastq/20250115_NextSeq2000/A2001_clean_FASTQ/$line >> fq_2_file

done < right

cat file | cut -d. -f1 | sed 's|_R1_001||' | sed 's|_R2_001||' |   sort | uniq > name 

echo 'pair_id,fq_1,fq_2' > temp1
paste name left right  | tr '\t' ',' > temp2
cat temp1 temp2 > file1.csv

##################
# create pair_id,fq_1,fq_2,downsample
##################

# Print the header
echo "pair_id,fq_1,fq_2,downsample"

# Read file2.csv and match with file1.csv
while IFS=',' read -r pair_id downsample; do
    # Skip the header line
    if [[ "$pair_id" == "pair_id" ]]; then
        continue
    fi

    # Find the matching row in file1.csv
    grep "^$pair_id," file1.csv | while IFS=',' read -r id fq1 fq2; do
        echo "$id,$fq1,$fq2,$downsample"
    done
done < file2.csv > file3.csv


###################
# add in the output file name
#####################

awk -F',' 'NR==1 {print $0",out_fq_1,out_fq_2"; next} 
         {out_fq_1=$1"_"$4"_R1_001.fastq.gz"; out_fq_2=$1"_"$4"_R2_001.fastq.gz"; 
         print $0","out_fq_1","out_fq_2}' file3.csv > samplesheet.csv