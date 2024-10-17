#!/bin/bash

fq=$1
#fq=Undetermined_S0_R1_001.fastq.gz

zcat < $fq \
 | paste - - - - \
 | cut -f1 \
 | cut -d: -f10 \
 | cut -d+ -f2 \
 | head -n 100000 \
 | sort \
 | uniq -c \
 | sort -nr \
 | head 


