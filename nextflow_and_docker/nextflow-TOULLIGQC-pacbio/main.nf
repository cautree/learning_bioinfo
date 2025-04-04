#!/usr/bin/env nextflow


include { RE_HEADER } from './modules/re_header.nf'
include { TOULLIGQC } from './modules/ToulligQC.nf'


workflow {
  
    input_ch = Channel.fromPath("s3://seqwell-projects/20250328_pacbio_fornax/NGS250318SW_hifi_reads/test_5pct.bam")
            .map{ it-> tuple(it.baseName, it)}

    re_headered_read = RE_HEADER(input_ch)
    TOULLIGQC(re_headered_read)

}