#!/bin/bash

run=220125_NovaSeq
analysis=hg38_20M
plates=20M_FASTQ
wgs=true
ref=hg38.no_alt
hybrid=false


/software/nextflow-align/nextflow run \
align.nf \
-work-dir s3://seqwell-dev/work/$run/work \
 -c nextflow.config \
 --plate $plates \
--hybrid  $hybrid \
--run $run \
 --outfile ${run}_${analysis} \
 --ref $ref \
 --wgs $wgs \
 -bg -resume
