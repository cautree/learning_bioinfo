#!/bin/bash

run="20241213_NextSeq2000"
human_genome="HG001"

/software/nextflow-align/nextflow run \
concordance.nf \
-c nextflow.config \
--run $run \
--human_genome $human_genome \
--resume -bg 