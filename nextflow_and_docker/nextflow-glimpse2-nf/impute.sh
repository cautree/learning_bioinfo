#!/usr/bin/bash


outdir=NA12878_chr22
samplesheet=sample_bam_impute.csv
run=test
human_genome=HG001

nextflow run phaseimpute  -profile docker \
-c /home/yanyan/glimpse2-nf-analysis/common/nextflow.config \
--outdir nf_phase_out_${outdir} \
-resume -bg \
--genome GRCh38 \
--tools glimpse2 \
--panel /home/yanyan/glimpse2-nf-analysis/common/panel_chr22.csv \
--steps impute \
--input samplesheet/${samplesheet} \
--chunks /home/yanyan/glimpse2-nf-analysis/common/chunks_chr22.csv

aws s3 sync nf_phase_out_${outdir}/imputation/glimpse2/samples/  s3://seqwell-users/yanyan/glimpse2-impute/$run/$human_genome/

