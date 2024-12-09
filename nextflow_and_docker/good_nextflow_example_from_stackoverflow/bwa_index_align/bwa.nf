process bwa_index {

    input:
    path ref_fasta
    val prefix

    output:
    tuple val(prefix), path("${prefix}.{ann,amb,sa,bwt,pac}")
    
    //bwa index -p STR    prefix of the index [same as fasta name]


    """
    bwa index \\
        -p "${prefix}" \\
        "${ref_fasta}"
    """
}


process bwa_mem {

    tag { sample_id }

    input:
    tuple val(sample_id), path(reads)
    tuple val(idxbase), path("bwa_index/*")

    output:
    tuple val(sample_id), path("${sample_id}.aln.bam")

    script:
    def task_cpus = task.cpus > 1 ? task.cpus - 1 : task.cpus

    //samtools view -1, --fast    Use fast BAM compression (and default to --bam)
    
    """
    bwa mem \\
        -t ${task_cpus} \\
        "bwa_index/${idxbase}" \\
        ${reads} |
    samtools view \\
       -1 \\
       -o "${sample_id}.aln.bam" \\
       -
    """
}