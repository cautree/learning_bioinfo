#!/usr/bin/bash

samplesheet="20241106_MiSeq-Yoda.csv"
output_path="s3://seqwell-analysis/20241106_MiSeq-Yoda/fulcrum/"

nextflow \
  -log ".nextflow/nextflow.log" \
  run \
  -resume \
  -profile awsbatch \
  -work-dir "s3://seqwell-dev/work/" \
    ../main.nf \
        --input "${PWD}/${samplesheet}" \
        --output "${output_path}" \
        --fasta "s3://seqwell-codexis/references/hg38/hg38.fa" \
        --fasta_index "s3://seqwell-codexis/references/hg38/hg38.fa.fai" \
        --bwa_index "s3://seqwell-codexis/references/hg38/" \
         -bg 