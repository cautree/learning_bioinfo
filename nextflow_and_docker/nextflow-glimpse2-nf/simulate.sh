#!/bin/bash

chr=$1
depth=$2

nextflow run phaseimpute \
    --input samplesheet/sample_bam.csv  \
    --steps simulate \
    --depth $depth \
    --outdir depth_simulated \
    --fasta reference_genome/chr${chr}.fa \
    -profile docker  \
    -resume -bg
mv depth_simulated/simulation/samples/* simulated_bam
