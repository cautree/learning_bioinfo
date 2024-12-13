#!/usr/bin/bash

outdir="20241210_Admera_health_chr22"

nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_out_${outdir} \
-resume -bg \
--genome "GRCh38" \
--tools "glimpse2" \
--panel panel.csv \
--steps "impute" \
--input samplesheet/sample_bam.csv \
--chunks chunks.csv