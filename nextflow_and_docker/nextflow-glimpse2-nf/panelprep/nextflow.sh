#!/usr/bin/bash

run="test"
samplesheet="sample_bam.csv"

nextflow run nf-core/phaseimpute -r dev -profile docker \
-c /home/ec2-user/common/nextflow.config \
--outdir  output \
-resume -bg \
--genome "GRCh38" \
--tools "glimpse2" \
--panel /home/ec2-user/common/panel_chr22_panelprep.csv \
--steps "panelprep" 
