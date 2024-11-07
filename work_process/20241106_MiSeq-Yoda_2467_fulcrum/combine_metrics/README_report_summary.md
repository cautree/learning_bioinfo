
file_path=$1
output_spreadsheet_path=$2

#file_path=s3://seqwell-analysis/20241106_MiSeq-Yoda/fulcrum/
#output_spreadsheet_path="20241106_MiSeq-Yoda"

aws s3 cp  $file_path pipeline_output --exclude="*"  --include="*/*.txt" --recursive

cd pipeline_output
mv */*.txt .
cd ..

python combine_metrics.py $output_spreadsheet_path

rm -rf pipeline_output
