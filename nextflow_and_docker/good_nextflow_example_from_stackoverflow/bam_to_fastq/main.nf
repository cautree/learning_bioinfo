params.input_files = './path/to/bams/*.bam'


process bam2fastq {

    tag { library }

    input:
    tuple val(library), path(bam_file)

    output:
    tuple val(library), path("${library}.{1,2}.fastq.gz")

    //samtools fastq arguments: -o FILE      write reads designated READ1 or READ2 to FILE
    //samtools fastq arguments: -s FILE      write singleton reads designated READ1 or READ2 to FILE
    //samtools fastq arguments: -n           don't append /1 and /2 to the read name
    """
    samtools fastq \\
        -1 "${library}.1.fastq.gz" \\
        -2 "${library}.2.fastq.gz" \\
        -0 /dev/null \\
        -s /dev/null \\
        -n \\
        "${bam_file}"
    """
}

workflow {

    //smart way to get file name
    input_ch = Channel.fromFilePairs( params.input_files, size: 1 )

    bam2fastq( input_ch )

    bam2fastq.out.view()
} 