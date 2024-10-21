#/bin/bash

plates="20241017_MiSeq-Sharkboy_2424.csv"

nextflow run \
tagify_demux_nextflow/tagify_demux.nf \
-work-dir work/ \
--plates ${plates} \
-bg -resume
