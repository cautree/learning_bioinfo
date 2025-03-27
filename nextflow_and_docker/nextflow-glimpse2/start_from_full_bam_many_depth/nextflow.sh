#!/bin/bash

chr=chr22


/software/nextflow-align/nextflow run \
main.nf \
--chr $chr \
-bg -resume \
-profile docker
