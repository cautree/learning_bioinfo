

process get_chr22 {
  
  input:
  tuple val(pair_id), path(bam)
  
  output:
  tuple val(pair_id), path("*.chr22.bam"), path("*.bai")
  
  
  """
  samtools index $bam
  samtools view -b $bam chr22 > ${pair_id}.chr22.bam
  samtools index ${pair_id}.chr22.bam
  
  
  """

}


// Define the downsampling process
process simulate_bam {
  
    debug true
  
    publishDir path: "simulated_bam", mode:'copy'
    
    tag "$sample_id-$target_coverage"
    

    input:
    tuple val(sample_id), path(bam), path(bam_index), val(target_coverage)

    output:
    tuple val(sample_id), val(target_coverage), path("${sample_id}.*x.downsampled.bam"), path("${sample_id}.*x.downsampled.bam.bai")

    script:
    """
    downsample_bam.sh ${sample_id} ${bam} ${bam_index} ${target_coverage} 
    """
}


// 
process glimpse_impute {
  
  input:
  
  output:
  
  
  """
  
  
  """
  
  
  
}








nextflow.enable.dsl=2

params.target_coverages = [0.1, 0.2, 0.5, 1, 2] // Define target coverages

// Create a channel with BAM file paths (example paths, modify as needed)
bam_ch = Channel.fromPath("bam/*.bam").map { bam -> 
    def sample_id = bam.baseName.tokenize(".")[0]
    tuple(sample_id, bam)
}

index_ch = Channel.fromPath("bam/*.bai").map { index -> 
    def sample_id = index.baseName.tokenize(".")[0]
    tuple(sample_id, index)
}

bam_index_ch = bam_ch.join( index_ch)

bam_index_ch.view()

// Expand BAM files to process each with multiple coverages
expanded_ch = bam_index_ch
    .flatMap { sample_id, bam, index -> 
        params.target_coverages.collect { coverage -> 
            tuple(sample_id, bam, index, coverage) 
        }
    }
    
expanded_ch.view()


// Run the process
workflow {
    expanded_ch | simulate_bam | view { sample_id, coverage, bam, bai -> 
        println "Generated: $bam for sample: $sample_id at $coverage x"
    }
}
