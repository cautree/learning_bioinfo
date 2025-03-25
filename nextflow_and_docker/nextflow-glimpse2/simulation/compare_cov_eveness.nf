nextflow.enable.dsl=2



process CALCULATE_COVERAGE {
    tag "$pair_id"
    input:
        tuple val(pair_id), path(bam)
    output:
        tuple val(pair_id), path("${pair_id}_coverage.txt")
    script:
    """
    samtools depth $bam > ${pair_id}_coverage.txt
    """
}

process COMPUTE_STATS {
  
    publishDir path: "output", mode: 'copy'
    
    tag "$pair_id"
    input:
        tuple val(pair_id), path(coverage)
    output:
        tuple val(pair_id), path("${pair_id}_stats.txt")
    script:
    """
    awk '{sum+=\$3; sumsq+=\$3*\$3} END {print sqrt(sumsq/NR - (sum/NR)**2)/(sum/NR)}' $coverage > ${pair_id}_stats.txt
    """
}


workflow {
    pairs = Channel.fromPath("output/*.bam")
            .map{ it-> tuple(it.baseName.tokenize(".")[0], it)}
    
    cov = CALCULATE_COVERAGE(pairs)
    
    stats = cov | COMPUTE_STATS
    
    
}


