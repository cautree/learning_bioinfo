#!/bin/bash
run="20241210_Admera_health"
analysis="Human_1x"


/software/nextflow-align/nextflow run \
glimpse_impute.nf \
-c nextflow.config_batch \
-work-dir "s3://seqwell-dev/nextflow-work-dir/" \
--run $run \
--analysis $analysis \
-bg -resume 
