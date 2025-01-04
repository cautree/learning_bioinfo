#!/bin/bash

run="20241127_NextSeq2000"
analysis="hc"
dev=true



/software/nextflow-align/nextflow run mosdepth.nf \
--run $run \
--analysis $analysis \
--dev $dev \
-bg -resume
