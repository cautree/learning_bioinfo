#!/bin/bash

set -e


################################################################################################
#how to run
#bash combine_metrics.sh s3://seqwell-analysis/20241106_MiSeq-Yoda/fulcrum/ 20241106_MiSeq-Yoda.xlsx 1>log 2& > log
################################################################################################


############################
#step1: create excel report
############################

file_path=$1
output_spreadsheet_path=$2

#file_path=s3://seqwell-analysis/20241106_MiSeq-Yoda/fulcrum/
#output_spreadsheet_path="20241106_MiSeq-Yoda.xlsx"
mkdir -p pipeline_output
aws s3 cp  $file_path pipeline_output --exclude="*"  --include="*/*.txt" --recursive

cd pipeline_output
mv */*.txt .
cp ../combine_metrics.py .
python combine_metrics.py ../$output_spreadsheet_path
cd ..
rm -rf pipeline_output

#############################
#step2: upload excel report to the s3 bucket
##############################
mkdir -p upload 
cp $output_spreadsheet_path upload
cd upload
aws s3 sync . $file_path
cd .. 
rm -rf upload

echo "upload to s3 finished"