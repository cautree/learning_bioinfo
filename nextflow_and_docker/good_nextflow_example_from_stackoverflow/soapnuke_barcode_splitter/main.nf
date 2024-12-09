params.reads = "/data/mPCR/220213_I7_V350055104_L3_SZPVL22000812-81/*_{1,2}.fq.gz"
params.index = "/home/duxu/project/data/index.list"
params.output = 'results'

reads_ch = Channel.fromFilePairs( params.reads )
index = file( params.index )


process soapnuke {

    tag { sample }

    publishDir "${params.outdir}/SOAPnuke", mode: 'copy'
    conda 'soapnuke'

    input:
    tuple val(sample), path(reads) from reads_ch

    output:
    tuple val(sample), path('clean{1,2}.fastq.gz') into clean_reads_ch

    script:
    def (rawfq1, rawfq2) = reads

    """
    SOAPnuke filter \\
        -1 "${rawfq1}" \\
        -2 "${rawfq2}" \\
        -l 12 \\
        -q 0.5 \\
        -Q 2 \\
        -o . \\
        -C "clean1.fastq.gz" \\
        -D "clean2.fastq.gz"
    """
}

process barcode_splitter {

    tag { sample }

    publishDir "${params.outdir}/barcode_splitter", mode: 'copy'
    conda 'barcode_splitter'

    input:
    tuple val(sample), path(reads) from clean_reads_ch
    path index

    output:
    tuple val(sample), path('*-read-{1,2}.fastq.gz') into trimmed_index

    script:
    def (splitfq1, splitfq2) = reads

    """
    barcode_splitter \\
        --bcfile \\
        "${index}" \\
        "${split1}" \\
        "${split2}" \\
        --idxread 1 2 \\
        --mismatches 1 \\
        --suffix ".fastq" \\
        --gzipout
    """
}

//https://stackoverflow.com/questions/71985446/nextflow-report-an-error-no-such-variable-from