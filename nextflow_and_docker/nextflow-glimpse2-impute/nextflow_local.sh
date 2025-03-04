#!/bin/bash
run="20241210_Admera_health"
analysis="Human_1x"


/software/nextflow-align/nextflow run \
glimpse_impute.nf \
-c nextflow.config \
--run $run \
--analysis $analysis \
-bg -resume 
