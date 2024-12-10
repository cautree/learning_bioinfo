params.metadata = './metadata.csv'
params.outdir = './results'


process concat_reads {

    tag { sample_name }

    publishDir "${params.outdir}/concat_reads", mode: 'copy'

    input:
    tuple val(sample_name), path(fastq_files)

    output:
    tuple val(sample_name), path("${sample_name}.${extn}")

    script:
    if( fastq_files.every { it.name.endsWith('.fastq.gz') } )
        extn = 'fastq.gz'
    else if( fastq_files.every { it.name.endsWith('.fastq') } )
        extn = 'fastq'
    else
        error "Concatentation of mixed filetypes is unsupported"

    """
    cat ${fastq_files} > "${sample_name}.${extn}"
    """
}



process pomoxis {

    tag { sample_name }

    publishDir "${params.outdir}/pomoxis", mode: 'copy'

    cpus 18

    input:
    tuple val(sample_name), path(fastq)

    """
    mini_assemble \\
        -t ${task.cpus} \\
        -i "${fastq}" \\
        -o results \\
        -p "${sample_name}"
    """
}



workflow {

    fastq_extns = [ '.fastq', '.fastq.gz' ]

    Channel.fromPath( params.metadata )
        | splitCsv()
        | map { dir, sample_name ->

            all_files = file(dir).listFiles()

            fastq_files = all_files.findAll { fn ->
                fastq_extns.find { fn.name.endsWith( it ) }
            }

            tuple( sample_name, fastq_files )
        }
        | concat_reads
        | pomoxis
}