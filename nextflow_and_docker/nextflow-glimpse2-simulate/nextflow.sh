#!/bin/bash


run="20250117_NextSeq2000"
analysis="hg38_align"
dev=true


/software/nextflow-align/nextflow run glimpse_simulate.nf \
--run $run \
--analysis $analysis \
--dev $dev \
-bg -resume
