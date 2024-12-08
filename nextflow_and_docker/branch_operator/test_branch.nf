nextflow.enable.dsl=2

process test {

    errorStrategy 'ignore'

    input:
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("output/abundance.tsv")

    """
    if [ "${fastq.baseName}" == "empty" ]; then
        exit 1
    fi
    mkdir output
    touch output/abundance.tsv
    """
}

workflow {

    fastqs = Channel.fromFilePairs( './data/*.fastq', size: 1 )

    test(fastqs) \
        .join(fastqs, remainder: true) \
        .branch { name, abundance, fastq_tuple ->
            failed: abundance == null
                return tuple( name, *fastq_tuple )
            succeeded: true
                return tuple( name, abundance )
        } \
        .set { results }

    results.failed.view { "failed: $it" }
    results.succeeded.view { "success: $it" }
}
