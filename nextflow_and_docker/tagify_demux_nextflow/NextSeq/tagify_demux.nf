#!/home/ec2-user/nextflow/nextflow

params.dev = false

//params.plates = "/home/ec2-user/data/20210112_MiSeq/20210112_MiSeq.txt"
params.plates = "20230621_MiSeq-Sharkboy_1654.csv"
run_manifest = file(params.plates)
bcl_name = run_manifest.baseName
run_name = bcl_name.split('_')[0..1].join('_')

manifest_ch = Channel.value(run_manifest)

if(params.dev) {
   path_s3 = "seqwell-dev/fastq"
   path_dashboard = "seqwell-dev/dashboard/fastq"
   path_cluster = "seqwell-dev/dashboard/cluster"
} else {
   path_s3 = "seqwell-fastq"
   path_dashboard = "seqwell-dashboard/fastq"
   path_cluster = "seqwell-dashboard/cluster"
}

barcodes_ch= Channel.fromPath("s3://seqwell-ref/barcodes/*")
                                      .collect()
process samplesheet {

    stageInMode 'copy'

    input:
    path manifest from manifest_ch
    path barcodes from barcodes_ch

    output:
    path("*_samplesheet.csv") into samplesheet_ch
    path("*.txt") into manifest_out

    publishDir ".", mode: "copy"
    publishDir path: "s3://$path_s3/${run_name}/"

    """
    cat $manifest > ${manifest.baseName}.manifest.txt
    make_samplesheet.py $manifest
    """

}

process bscp {

     output:
     path("${run_name}_BCL") into bcl_ch
     path("Run*.xml") into run_info_ch
     path("InterOp") into interop_ch

     publishDir path: "s3://$path_cluster/${run_name}/", pattern: "InterOp"
     publishDir path: "s3://$path_cluster/${run_name}/", pattern: "*.xml"
     publishDir path: "xml", pattern: "*.xml", mode: "copy"
     publishDir path: "bcl", pattern: "*.BCL", mode: "copy"

     """
     bs download run --exclude="*jpg" --name ${bcl_name} -o ${run_name}_BCL
     cp ${run_name}_BCL/Run*xml .
     cp -r ${run_name}_BCL/InterOp .
     """
}

run_info_ch.view()
interop_ch.view()

process bcl2fq {

     input:
     path(bcl) from bcl_ch
     path(samplesheet) from samplesheet_ch

     output:
     path("*FASTQ/*_001.fastq.gz") into raw_fq_ch
     path("*txt") into demux_stats
     path("*FASTQ") into fq_dir
     path("*tar.gz") into demux_dir
     path("Undetermined*gz") into undetermined
     path("*.xlsx") into demux_report

     publishDir ".", mode: "copy", pattern: "*.txt"
     publishDir ".", mode: "copy", pattern: "*_FASTQ"
     publishDir ".", mode: "copy", pattern: "*gz"
      publishDir ".", mode: "copy", pattern: "*.xlsx"

     publishDir path: "s3://$path_s3/${run_name}/", pattern: "*.txt"
     publishDir path: "s3://$path_s3/${run_name}/", pattern: "*_FASTQ"
     publishDir path: "s3://$path_s3/${run_name}/", pattern: "*.gz"
     publishDir path: "s3://$path_s3/${run_name}/", pattern: "*.xlsx"

     publishDir path: "s3://$path_dashboard/", pattern: "*.xlsx"

     """
     bcl2fastq -R $bcl \
      -o . \
      --reports-dir ${run_name} \
      --sample-sheet $samplesheet \
      --use-bases-mask Y150,I10,Y10I10,Y150 \
      --create-fastq-for-index-reads \
      --mask-short-adapter-reads 0 \
      --no-lane-splitting
     
     
     rename   's/_S[0-9]_R/_R/' */*fastq.gz
     rename   's/_S[0-9][0-9]_R/_R/' */*fastq.gz
     rename   's/_S[0-9][0-9][0-9]_R/_R/' */*fastq.gz
     rename   's/_S[0-9][0-9][0-9][0-9]_R/_R/' */*fastq.gz
     rename   's/_S[0-9][0-9][0-9][0-9][0-9]_R/_R/' */*fastq.gz

     rename   's/_S[0-9]_I/_I/' *FASTQ/*gz
     rename   's/_S[0-9][0-9]_I/_I/' *FASTQ/*gz
     rename   's/_S[0-9][0-9][0-9]_I/_I/' *FASTQ/*gz
     rename   's/_S[0-9][0-9][0-9][0-9]_I/_I/' *FASTQ/*gz
     

     tar czfv ${run_name}.tar.gz ${run_name}

     demux_report.py ${run_name}
     """
}


