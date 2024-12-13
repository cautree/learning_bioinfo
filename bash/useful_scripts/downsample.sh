#!/bin/bash

printf '0.1%.0s\n' {1..18}} > a
printf '0.5%.0s\n' {1..18}} > b
printf '0.01%.0s\n' {1..18}} > c
cat a b c > ratio
ls | grep R1 | cut -d_ -f1-2 > file
cat file file file > file_3
paste file_3 ratio > file_ratio
#cat file_ratio | head -1 > file_ratio_test
mkdir -p output
while read pair_id downsample; do
read1=${pair_id}_R1_001.fastq.gz
read2=${pair_id}_R2_001.fastq.gz

    /usr/local/bbmap/reformat.sh \
     -Xmx60G \
     in1=$read1 \
     in2=$read2 \
     out1=${pair_id}.${downsample}_R1_001.fastq.gz \
     out2=${pair_id}.${downsample}_R2_001.fastq.gz \
     samplerate=${downsample} \
     sampleseed=13
     
mv ${pair_id}.${downsample}_R1_001.fastq.gz output
mv ${pair_id}.${downsample}_R2_001.fastq.gz output
done < file_ratio
