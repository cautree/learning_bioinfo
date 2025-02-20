nextflow.enable.dsl=2

process get_chr22 {
  
  input:
  tuple val(pair_id), path(bam)
  
  output:
  tuple val(pair_id), path("*.chr22.bam"), path("*.chr22.bam.bai")
  
  
  """
  samtools index $bam
  samtools view -b $bam chr22 > ${pair_id}.chr22.bam
  samtools index ${pair_id}.chr22.bam
  """

}


// Define the downsampling process
process simulate_bam {
  
    publishDir path: "s3://$path_s3/$params.run/$params.analysis/simulated_bam"
  
    debug true
  
    publishDir path: "simulated_bam", mode:'copy'
    
    tag "$sample_id-$target_coverage"
    

    input:
    tuple val(sample_id), path(bam), path(bam_index), val(target_coverage)

    output:
    tuple val(sample_id), path("${sample_id}.*x.downsampled.bam"), path("${sample_id}.*x.downsampled.bam.bai")

    script:
    """
    downsample_bam.sh ${sample_id} ${bam} ${bam_index} ${target_coverage} 
    """
}



process create_samplesheet {
  
  publishDir path: "s3://$path_s3/$params.run/$params.analysis/simulated_bam"
  publishDir "samplesheet", mode: 'copy'
  
  input:
  path( bam_bai)
  
  output:
  path("*.csv")
  
  
  """
  ls | grep .bam | grep -v bai |sed 's|^|bam/||' > bam_file
  ls | grep .bai | sed 's|^|bam/||' > index_file
  cat bam_file | cut -d. -f1 | cut -d/ -f2 | sed 's|_||g' > pair_id
  
  echo "sample,file,index" >> ${params.run}.glimpse2.samplesheet.csv
  paste pair_id bam_file index_file | tr '\t' ','  >> ${params.run}.glimpse2.samplesheet.csv
  
  
  """
  
  
  
  
}


params.target_coverages = [0.1, 0.2, 0.5, 1, 2] // Define target coverages
params.run = "20250117_NextSeq2000"
params.analysis = "hg38_align"
params.dev = false
params.number_of_inputs = 2
if(params.dev) { 
   path_s3 = "seqwell-dev/analysis"
} else { 
   path_s3 = "seqwell-analysis"
}





// Create a channel with BAM file paths (example paths, modify as needed)
bam_ch = Channel.fromPath("s3://seqwell-analysis/" + params.run + "/" + params.analysis + "/bam/*.md.bam")
   .filter { !it.name.endsWith('.bai') }
   .map { bam -> 
    def sample_id = bam.baseName.tokenize(".")[0]
    tuple(sample_id, bam)
    }
   .take( params.dev ? params.number_of_inputs : -1 )



// Run the process
workflow {
  
  bam_index_chr22_ch = get_chr22( bam_ch)
  
  bam_index_chr22_ch.view()

// Expand BAM files to process each with multiple coverages
expanded_ch = bam_index_chr22_ch
    .flatMap { sample_id, bam, index -> 
        params.target_coverages.collect { coverage -> 
            tuple(sample_id, bam, index, coverage) 
        }
    }
    
expanded_ch.view()
  
    bam_chr22 = simulate_bam (expanded_ch)
    
    bam_chr22_all = bam_chr22
                   .map{ it -> tuple( it[1], it[2])}
                  .flatten()
                  .collect()
    create_samplesheet(bam_chr22_all)
    
}
