#!/bin/bash

bam=$1
sample_id=$(basename $1 .disc.bam)

samtools view -h ${bam} | awk -v threshold=1000 '{
    if ($0 ~ /^@/) {
        print $0;
    } else {
        insert_size = ($9 < 0) ? -$9 : $9;
        if (insert_size >= threshold) {
            print $0;
        }
    }
}' | samtools view -Sb - > ${sample_id}_large_insert_filtered.bam

#-0 /dev/null: Any single-end reads (those without a mate) are discarded.
#-s /dev/null: Any unpaired reads (those that are part of a pair but have no valid mate) are discarded.
samtools fastq -1 ${sample_id}_large_insert_R1.fastq \
               -2 ${sample_id}_large_insert_R2.fastq \
               -0 /dev/null \
               -s /dev/null \
               ${sample_id}_large_insert_filtered.bam