#/bin/bash


/software/nextflow-align/nextflow run \
main.nf \
-work-dir s3://seqwell-users/yanyan/work-dir-long-reads-QC/work \
-bg -resume