#!/bin/bash

#aws s3 ls s3://seqwell-analysis/202404 | cut -c32- | sed 's|/||' >>test_archive_bam_run
#aws s3 ls s3://seqwell-analysis/202405 | cut -c32- | sed 's|/||' >>test_archive_bam_run
#aws s3 ls s3://seqwell-analysis/202406 | cut -c32- | sed 's|/||' >>test_archive_bam_run
#aws s3 ls s3://seqwell-analysis/202407 | cut -c32- | sed 's|/||' >>test_archive_bam_run

while read line; do
echo $line

aws s3 cp s3://seqwell-analysis/$line/  s3://seqwell-analysis/$line/ --recursive --exclude="*" --include="*/bam/*" --storage-class DEEP_ARCHIVE 

done < test_archive_bam_run