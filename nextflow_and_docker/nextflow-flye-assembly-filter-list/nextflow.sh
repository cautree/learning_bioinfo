#!/bin/bash

/software/nextflow-align/nextflow run \
main_range.nf \
-c nextflow.config_local \
--output s3://seqwell-dev/pacbio_assemble_res/ \
-resume -bg 

nextflow-flye-assembly-filter-list