#!/usr/bin/bash

run="20250117_nextseq"
samplesheet="sample_bam.csv"

nextflow run nf-core/phaseimpute -r dev -profile docker \
-c /home/ec2-user/common/nextflow.config_batch \
--outdir glimpse_batch \
-work-dir s3://seqwell-users/yanyan/glimpse_batch_test_workdir \
-resume -bg \
--genome "GRCh38" \
--tools "glimpse2" \
--panel /home/ec2-user/common/panel_chr1.csv \
--steps "impute" \
--input samplesheet/${samplesheet} \
--chunks /home/ec2-user/common/chunks_chr1.csv
