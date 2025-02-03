workflow {
    Channel.fromPath("data/samplesheet.csv")
    | splitCsv( header:true )
    | map { row ->
        meta = row.subMap('id', 'repeat', 'type')
        [meta, [
            file(row.fastq1, checkIfExists: true),
            file(row.fastq2, checkIfExists: true)]]
    }
    | set { samples }


    samples
    | map { sleep 10; it }
    | view { meta, reads -> "Should be unmodified: $meta" }

  //  samples
  //  | map { meta, reads ->
  //      meta.type = meta.type == "tumor" ? "abnormal" : "normal"
  //      [meta, reads]
  //  }
  //  | view { meta, reads -> "Should be modified: $meta" }

//Should be modified: [id:sampleA, repeat:1, type:normal]
//Should be modified: [id:sampleA, repeat:1, type:abnormal]
//Should be modified: [id:sampleA, repeat:1, type:normal]
//Should be unmodified: [id:sampleA, repeat:1, type:normal]
//Should be unmodified: [id:sampleA, repeat:1, type:abnormal]
//Should be unmodified: [id:sampleA, repeat:1, type:normal]

    samples
    | map { meta, reads ->
        newmap = [type: meta.type == "tumor" ? "abnormal" : "normal"]
        [meta + newmap, reads]
    }
    | view { meta, reads -> "Should be modified: $meta" }

//Should be modified: [id:sampleA, repeat:1, type:normal]
//Should be modified: [id:sampleA, repeat:1, type:abnormal]
//Should be modified: [id:sampleA, repeat:1, type:normal]
//Should be unmodified: [id:sampleA, repeat:1, type:normal]
//Should be unmodified: [id:sampleA, repeat:1, type:tumor]
//Should be unmodified: [id:sampleA, repeat:1, type:normal]

}