workflow {
    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    meta = [['sample', 'replicate', 'type'], id.tokenize("_")]
        .transpose()
        .collectEntries()
    [meta, reads]
     }
    | view
}


//[[sample:sampleA, replicate:rep1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R2.fastq.gz]]
//[[sample:sampleA, replicate:rep1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R2.fastq.gz]]