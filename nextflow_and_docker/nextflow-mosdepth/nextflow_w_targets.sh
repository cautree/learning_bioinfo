#!/bin/bash

run="20241219_MiSeq-Appa"
analysis="align_w_artifact"
dev=true
targets=s3://seqwell-codexis/intervals/twist_hg38_exome_v2.0.2_probes_sorted_validated.annotated_0.no_alt.bed


/software/nextflow-align/nextflow run mosdepth.nf \
--run $run \
--analysis $analysis \
--dev $dev \
-bg -resume
