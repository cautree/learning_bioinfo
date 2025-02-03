workflow {
    numbers = Channel.of(1, 2)

    numbers
    | flatMap { n -> [ n, [n*10, n*100] ] }
    | view
}


//[[sample:sampleA, replicate:rep1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R2.fastq.gz]]
//[[sample:sampleA, replicate:rep1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R2.fastq.gz]]