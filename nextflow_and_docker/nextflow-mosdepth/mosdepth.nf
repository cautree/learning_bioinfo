
params.mosdepth_coverage_bin_width = 500
params.mosdepth_coverage_thresholds = "20,30"
params.targets = "NO_FILE"
params.run = "20250103_MiSeq-Appa"
params.analysis = "align_w_artifact"
params.dev = false
params.number_of_inputs = 2


if(params.dev) { 
   path_s3 = "seqwell-dev/analysis"
} else { 
   path_s3 = "seqwell-analysis"
}


(bam_ch1, bam_ch2) = Channel.fromPath("s3://seqwell-analysis/" + params.run + "/" + params.analysis + "/bam/*.md.bam")
                .map{ it -> tuple(it.baseName.replace(".md", ""), it)}
                .take( params.dev ? params.number_of_inputs : -1 )
                .into(2)
                
target_ch = Channel.fromPath(params.targets).first()
         

process INDEX_BAM {
  
    input:
    tuple val(sample_id), path(bam) from bam_ch1
    
    output:
    tuple val(sample_id), path("*bai") into index_ch
    
    """
    samtools index $bam
    """
}

bam_index_ch = bam_ch2.join(index_ch)


process MOSDEPTH {
    tag "${sample_id}"
   // publishDir "mosdepth_out", mode: 'copy'


    input:
    tuple val(sample_id), path(bam), path(index) from bam_index_ch
    path(targets) from target_ch

    output: 
    path("*.bed.gz")
    path("*.mosdepth.*.txt") into mos_out

    script:
    def intervals = targets.name != 'NO_FILE' ? targets : params.mosdepth_coverage_bin_width
    """
    mosdepth \\
        --threads ${task.cpus} \\
        --by ${intervals} \\
        --thresholds ${params.mosdepth_coverage_thresholds} \\
        ${bam.getBaseName()} \\
        ${bam}
    """

    
}

mos_out_all = mos_out.collect()


process MULTIQC {
  
   // publishDir "mosdepth_out", mode: 'copy'
    publishDir path: "s3://$path_s3/$params.run/$params.analysis/MosDepth" , mode: 'copy'

    input:
    path(qc_files) from mos_out_all

    output:
    path("*.html"), emit: report

    script:
    def datetime = new Date().format("yyyy-MM-dd_HH-mm-ss", TimeZone.getTimeZone("UTC"))
    def filename = datetime + "_multiqc_report.html"
    """
    # Ignore FASTQC in the general summary table because duplication rate is a poor estimate
    # Ignore mosdepth in the general summary table because bases >=30x seems incorrect
    # Ignore Picard HsMetrics in the general summary table because it is optional
    multiqc \\
        --cl-config 'table_columns_visible: { mosdepth: False }' \\
        --cl-config 'fn_clean_exts: [".downsampled", ".duplicate_metrics", ".markdup", ".marked", ".umi-grouped"]' \\
        --filename ${filename} \\
        --force \\
        --interactive \\
        --no-data-dir \\
        --verbose \\
        ./
    """

  
}



