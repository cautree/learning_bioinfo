nextflow.enable.dsl=2

params.fastq_files = "${baseDir}/FASTQ/*.fastq.gz"
params.publish_dir = "./results"


process trim_galore {

    tag { "${sample}:${fastq_file}" }
   
    //how to select some file to save in a different directory
    publishDir "${params.publish_dir}/TrimGalore", saveAs: { fn ->
        fn.endsWith('.txt') ? "trimming_reports/${fn}" : fn
    }

    cpus 8

    input:
    tuple val(sample), path(fastq_file)

    output:
    tuple val(sample), path('*_trimmed.fq.gz'), emit: trimmed_fastq_files
    path "${fastq_file}_trimming_report.txt", emit: trimming_report

    """
    trim_galore \\
        -j ${task.cpus} \\
        "${fastq_file}"
    """
}

workflow {
   //how to use getSimpleName()
    Channel.fromPath( params.fastq_files )
        | map { tuple( it.getSimpleName(), it ) }
        | set { sample_fastq_files }

    results = trim_galore( sample_fastq_files )

    results.trimmed_fastq_files.view()
}