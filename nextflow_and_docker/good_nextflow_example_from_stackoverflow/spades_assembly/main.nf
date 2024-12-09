params.resultsDir = './results'
params.saveMode = 'copy'

params.filePattern = "./*_R{1,2}.fastq.gz"



process spades {

    publishDir "${params.resultsDir}/spades", mode: params.saveMode

    input:
    tuple val(genomeName), path(genomeReads) 

    output:
    tuple val(genomeName), path("${genomeName}_scaffolds.fasta")

    script:
    def (r1, r2) = genomeReads

    """
    spades.py \\
        -k 21,33,55,77 \\
        --careful \\
        --only-assembler \\
        --pe1-1 "${r1}" \\
        --pe1-2 "${r2}" \\
        -o "${genomeName}"    

    mv \\
        "${genomeName}/scaffolds.fasta" \\
        "${genomeName}_scaffolds.fasta"
    """
}


workflow {
    
    Channel
        .fromFilePairs( params.filePattern )
        .set { ch_in_spades }

    spades( ch_in_spades )

    spades.out.view()
}