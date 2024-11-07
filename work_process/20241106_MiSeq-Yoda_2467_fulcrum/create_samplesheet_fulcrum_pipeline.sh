#!/bin/bash

###########################################################################################################################
# how to run 
# bash create_samplesheet_fulcrum_pipeline.sh s3://seqwell-fastq/20241106_MiSeq-Yoda/241106_SpL_FASTQ/  20241106_MiSeq-Yoda
###########################################################################################################################

fq_path=$1
run=$2

#fq_path=s3://seqwell-fastq/20241106_MiSeq-Yoda/241106_SpL_FASTQ/
#run=20241106_MiSeq-Yoda

aws s3 ls $fq_path | grep fastq.gz | grep -v md5 | awk '{$1=$1}1' OFS="," | cut -f 4 -d "," > file
cat file | sed 's|_R1_001.fastq.gz||' | sed 's|_R2_001.fastq.gz||' | sort | uniq > sample_ID

while read line; do
echo $fq_path/${line} >> path
done < file

cat path | grep R1 > R1 
cat path | grep R2 > R2

paste sample_ID  R1  R2  | tr '\t', ',' > sample
echo "sample_id,fastq_1,fastq_2" > header

cat header sample > ${run}.csv
rm sample header sample_ID file path R1 R2
