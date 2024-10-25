aws s3 ls s3://seqwell-projects/eremid_pacbio_20241008/hg38/bam/ | grep md.bam > file


while read line; do

aws s3 cp s3://seqwell-projects/eremid_pacbio_20241008/hg38/bam/$line  .

done < file