#!/bin/bash

/software/nextflow-align/nextflow run \
main.nf \
-resume -bg -profile docker
