process TOULLIGQC {
    input:
    tuple val(pair_id), path(read)

    output:
    path "qc_reports/${pair_id}_qc_report.html"

    script:
    """
    
    
    # Create a directory to store the report
    mkdir -p qc_reports/

    # Run TOULLIGQC with the FASTQ input file and generate an HTML report
    toulligqc -u $read -o qc_reports/${pair_id}_qc_report.html

    """
}