
# create a var name for sampe in fastqc
https://github.com/nextflow-io/nextflow/discussions/4261

```
//THIS WORKS
process FASTQC_SINGLE {
    tag "FASTQC on ${reads.getName().split("\\.")[0]}"
    container 'fastqc-multiqc:1.0.1'
    publishDir params.outdir, mode:'copy'

    input:
    path reads

    output:
    path "fastqc_${reads.getName().split("\\.")[0]}_logs" 

    script:
    def file_name_prefix = reads.getName().split("\\.")[0]
    """
    mkdir fastqc_${file_name_prefix}_logs
    fastqc -o fastqc_${file_name_prefix}_logs -f fastq -q ${reads}
    """
}

```