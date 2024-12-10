//https://stackoverflow.com/questions/78250503/nextflow-script-for-performing-quality-control-and-trimming-the-sequence


process FastQC {
  tag "Running FastQC on ${sampleid}"

  publishDir {
    path: "${params.fastqc_dir}/${fastq.baseName}",
    move: 'move',
  }

  input: 
    tuple val(sampleid), path(fastq)

  output:
    path("*.html")

  script:
    """
    fastqc ${fastq}
    """
}

process Trimmomatic {
  tag "Trimming ${sampleid}"

  publishDir {
    path: "${params.trimmed_dir}",
    move: 'copy',
  }
  
  input:
    tuple val(sampleid), path(fastq)

  output:
    path("*_trimmed.fastq.gz")

  script:
    """
    java -jar ${params.trimmomatic_jar} PE -threads 4 \
      ${fastq} ${sampleid}_trimmed.fastq.gz")} \
      ${sampleid}_unpaired.fastq.gz")} \
      ${sampleid}_unpaired.fastq.gz")}
    """
}




Channel
  .fromPath(${params.fastq_dir}/*{.fastq.gz,.fq.gz,.fastq,.fq})
  .map { it -> tuple( it.simpleName, it ) }
  .ifEmpty { error "Cannot find any fastq files in ${params.fastq_dir}" }
  .set { fastq_files }

workflow {
  FastQC(fastq_files)
  Trimmomatic(fastq_files)
}