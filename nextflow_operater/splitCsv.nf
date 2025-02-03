workflow {
    Channel.fromPath("data/samplesheet.csv")
    | splitCsv( header:true )
    | map { row ->
        meta = [id:row.id, repeat:row.repeat, type:row.type]
        [meta, [
            file(row.fastq1, checkIfExists: true),
            file(row.fastq2, checkIfExists: true)]]
    }
    | view



      Channel.fromPath("data/samplesheet.csv")
    | splitCsv( header:true )
    | map { row ->
        meta = row.subMap('id', 'repeat', 'type')
        [meta, [
            file(row.fastq1, checkIfExists: true),
            file(row.fastq2, checkIfExists: true)]]
    }
    | view

}


//[[id:sampleA, repeat:1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentA/sampleA_rep1_normal_R2.fastq.gz]]
//[[id:sampleA, repeat:1, type:normal], [/Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R1.fastq.gz, /Users/yanyan/Documents/GitHub/software/learning_bioinfo/nextflow_operater/data/reads/treatmentB/sampleA_rep1_normal_R2.fastq.gz]]