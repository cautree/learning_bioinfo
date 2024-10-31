#!/bin/bash

fastq_path="fastq/"



nextflow run trim.nf \
--fastq_path $fastq_path \
-bg -resume
