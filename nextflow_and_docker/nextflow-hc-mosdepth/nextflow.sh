#!/bin/bash

run=20241108_NextSeq2000
analysis=mos_test
plates=Watchmaker_FASTQ
wgs=true
ref=hg38.no_alt
downsample=117000000
artifact=true
dev=true
targets=s3://seqwell-codexis/intervals/twist_hg38_exome_v2.0.2_probes_sorted_validated.annotated_0.no_alt.bed


/software/nextflow-align/nextflow run \
hybrid.nf \
 -c nextflow.config \
 --plate $plates \
--targets $targets \
--run $run \
 --outfile ${run}_${analysis} \
 --ref $ref \
 --wgs $wgs \
 --artifact $artifact \
 --downsample $downsample \
--dev $dev \
 -bg -resume
