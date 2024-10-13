#!/bin/bash

date_range=202410

today=$(date +%Y%m%d)
yesterday=$(date -r $(( $(date '+%s') -   86400 )) '+%Y%m%d')

#######################
#clean up the fastq bucket
#######################
aws s3 ls s3://seqwell-fastq/ | grep -E $date_range | cut -c32- | sed 's|/||g' > run_name
cat run_name | cut -c1-8 > date

paste date run_name > run_info

cat run_info | awk -v var=$yesterday '{ if( $1< var) print $2}' > run_analysis_work_to_rm

while read line; do
aws s3 rm  s3://seqwell-fastq/$line/work/ --recursive 
done < run_analysis_work_to_rm

rm run_name date run_info run_analysis_work_to_rm

#######################
#clean up the analysis bucket
#######################

aws s3 ls s3://seqwell-analysis/ | grep -E $date_range | cut -c32- | sed 's|/||g' > run_name
cat run_name | cut -c1-8 > date

paste date run_name > run_info

cat run_info | awk -v var=$yesterday '{ if( $1< var) print $2}' > run_fq_work_to_rm

while read line; do
aws s3 rm s3://seqwell-analysis/$line/ --recursive --exclude="*" --include="*/work/*" 
done < run_fq_work_to_rm




