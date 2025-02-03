workflow {
    Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
    | map { id, reads ->
    (sample, replicate, type) = id.tokenize("_")
    meta = [sample:sample, replicate:replicate, type:type]
    [meta, reads]
    }
    | view
}