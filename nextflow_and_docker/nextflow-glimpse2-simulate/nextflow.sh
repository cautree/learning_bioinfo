#!/bin/bash


run="20241213_NextSeq2000"
analysis="hg38_20.5M_1X"
dev=false


/software/nextflow-align/nextflow run glimpse_simulate.nf \
-work-dir s3://seqwell-dev/nextflow-work-dir/work/ \
-c nextflow.config \
--run $run \
--analysis $analysis \
--dev $dev \
-bg -resume

