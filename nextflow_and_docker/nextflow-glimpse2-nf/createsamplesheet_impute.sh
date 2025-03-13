#!/bin/bash


bam_folder_path=${PWD}/simulated_bam

ls $bam_folder_path | grep bam | grep bai > index_list
ls $bam_folder_path | grep bam |  grep -v bai > bam_list


cat bam_list | sed -E 's/\.bam$//; s/[-_.]//g'  > sample_id

while read index; do
echo ${bam_folder_path}/$index >> index_column
done < index_list

while read bam; do
echo ${bam_folder_path}/$bam >> bam_column
done < bam_list



echo sample,file,index > sample_bam_header
paste sample_id bam_column index_column | tr '\t' ',' >sample_bam_content
cat sample_bam_header sample_bam_content | grep -v bamlist > sample_bam_impute.csv
rm bam_column index_column sample_bam_header sample_bam_content bam_list index_list sample_id
cat sample_bam_impute.csv
mkdir -p  samplesheet
mv sample_bam_impute.csv samplesheet
