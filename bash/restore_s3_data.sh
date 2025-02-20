while read line; do 
aws s3 cp s3://SEQWELL/ARCHIVE/fastq/20211020_NextSeq/24UDI-20211018_FASTQ/$line . 
done < file
