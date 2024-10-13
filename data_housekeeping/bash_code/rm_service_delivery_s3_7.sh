#!/bin/bash

today=$(date +%Y%m%d)
days_90=$(date -r $(( $(date '+%s') -   90*86400 )) '+%Y-%m-%d')


#######################
#clean up the service delivery bucket
#######################
aws s3 ls s3://data.seqwell.com/ | grep -v PRE | cut -c32- | sed 's|/||g' > run_name
aws s3 ls s3://data.seqwell.com/ | grep -v PRE | cut -c1-10 > date

paste date run_name > run_info

#cat run_info | awk -v var=$days_90 '{ if( $1< var) print $0}' > run_service_to_rm_check
cat run_info | awk -v var=$days_90 '{ if( $1< var) print $2}' > run_service_to_rm 



while read line; do
echo $line
 #aws s3 rm  s3://data.seqwell.com/$line --dryrun
 aws s3 rm  s3://data.seqwell.com/$line  
done < run_service_to_rm

rm run_name date run_info run_service_to_rm