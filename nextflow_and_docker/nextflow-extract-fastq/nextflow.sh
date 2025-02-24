#!/bin/bash

/software/nextflow-align/nextflow run \
extract_fq.nf \
-work-dir s3://seqwell-dev/nextflow-work-dir/work \
-bg -resume