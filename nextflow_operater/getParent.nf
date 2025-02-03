workflow {
    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads.collect { it.getParent() }
    }
    | view

//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA]
//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB]

    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads*.getParent()
     }
    | view


//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA]
//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB]


Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads*.parent*.name
     }
    | view

//[treatmentA, treatmentA]
//[treatmentB, treatmentB]



Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads*.parent*.name*.minus(~/treatment/)
 }
    | view

//[A, A]
//[B, B]

Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
        (sample, replicate, type) = id.tokenize("_")
        (treatmentFwd, treatmentRev) = reads*.parent*.name*.minus(~/treatment/)
        meta = [
            sample:sample,
            replicate:replicate,
            type:type,
            treatmentFwd:treatmentFwd,
            treatmentRev:treatmentRev,
        ]
        [meta, reads]
    }
    | view

//[[sample:sampleA, replicate:rep1, type:normal, treatmentFwd:A, treatmentRev:A], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R2.fastq.gz]]
//[[sample:sampleA, replicate:rep1, type:normal, treatmentFwd:B, treatmentRev:B], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R2.fastq.gz]]

}

