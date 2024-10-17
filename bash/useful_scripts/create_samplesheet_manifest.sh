#!/bin/bash

samplesheet_from_bs=$1
runName=$2
cat $samplesheet_from_bs | grep Sample |  tr '\t' ',' | awk -F, -v OFS="," '{print  $9,  $4, $6}' > sample1
cat $samplesheet_from_bs | grep Sample | awk -F, -v OFS="," '{print  $10}' > sample2
cat sample2 | tr '\t' ',' > sample3
paste sample1 sample3 | tr '\t' ','  | sed 's|I7_Index_ID|i7|' | sed 's|I5_Index_ID|i5|' > ${runName}.csv
rm sample?
