#!/bin/bash

run=20241015_MiSeq-Yoda
analysis=artifacts
plates=*_FASTQ
ref=hg38
downsample=500000
artifact=true
dev=true
number_of_inputs=2
artifact=true


/software/nextflow-align/nextflow run \
 /software/nextflow-align/align_with_seq_artifact.nf \
 -work-dir s3://seqwell-dev/work/$run/$analysis/work/ \
 --plate $plates \
 --outfile ${run}_${analysis} \
 --ref $ref \
 --artifact $artifact \
 --downsample $downsample \
 --number_of_inputs $number_of_inputs \
 --dev $dev \
 -bg -resume