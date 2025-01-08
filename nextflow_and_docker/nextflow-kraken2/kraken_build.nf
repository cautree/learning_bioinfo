nextflow.enable.dsl=1



process KRAKEN2 {



  publishDir "kraken2-build", mode:"copy"

output:
path ("*")


script:

"""
kraken2-build --download-library bacteria --db data-base --threads 8  --use-ftp
"""
}