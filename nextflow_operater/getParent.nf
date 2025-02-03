workflow {
    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads.collect { it.getParent() }
    }
    | view



    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    reads*.getParent()
     }
    | view
}


//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA]
//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA]
//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB]
//[/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB]