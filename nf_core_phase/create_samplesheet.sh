#!/bin/bash

bam_folder_path=/home/ec2-user/20241210_Admera_health_nf_impute/bam

ls | grep bai > index_list
ls | grep -v bai > bam_list


cat bam_list | cut -d. -f1-2 | cut -d. -f1 | cut -d_ -f2 > id1
printf 'x%.0s\n' {1..72}} > id2
cat bam_list | cut -d. -f3-4 | sed 's/chr22.bam/1/g' > id3
cat bam_list 
paste id1 id2 id3 | tr -d '\t' | sed 's|\.||g' | sed 's|_||g' | grep S > sample_id

while read index; do
echo ${bam_folder_path}/$index >> index_column
done < index_list

while read bam; do
echo ${bam_folder_path}/$bam >> bam_column
done < bam_list

echo sample,file,index > sample_bam_header
paste sample_id bam_column index_column | tr '\t' ',' >sample_bam_content
cat sample_bam_header sample_bam_content | grep S > sample_bam.csv