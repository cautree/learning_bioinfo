#!/bin/bash

run_list=2024aug-oct-keep.csv

/software/nextflow-align/nextflow run bcl_from_bs_to_s3.nf \
-work-dir s3://seqwell-dev/fastq/work/ \
--run_list $run_list \
-resume -bg