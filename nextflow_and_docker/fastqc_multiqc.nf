nextflow.enable.dsl=2

process DOWNLOAD_FASTQ_REPORTS {
    tag "Download FastQ reports"
    publishDir path: "output",  mode: 'copy'   
    input:
    path(s3_paths)  // List of S3 paths to download from

    output:
    path("*")  // Output path where the FastQ reports will be saved

    script:
    """
    
    while read  s3_path  ; do
        aws s3 cp "\$s3_path" . --recursive 
    done < $s3_paths
    """
}

process RUN_MULTIQC {
    tag "Run MultiQC"
    container 'cautree/multiqc:latest'
    publishDir path: "multiqc_output",  mode: 'copy'
    input:
    path(fastq_reports)  // Directory containing FastQ reports

    output:
    path("*")  // Output directory for the MultiQC report

    script:
    """
    mkdir output
    mv *.zip output
    mkdir -p multiqc_report
    multiqc output  -o multiqc_report --verbose
    """
}

workflow  {
    // List of S3 paths (you can update this as per your data)
    s3_paths_ch = channel.fromPath("path.txt")

    // Download FastQ reports
    downloaded_reports = DOWNLOAD_FASTQ_REPORTS(s3_paths_ch)

    // Run MultiQC
    RUN_MULTIQC(downloaded_reports.collect())
}