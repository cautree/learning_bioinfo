 return in workflow block:
 return can be used so the statement below will not evaluated

 ## groupTuple and groupKey for fan in

 workflow {

    Channel.fromPath("data/intervals.bed")
    | splitCsv( header: ["chr", "start", "stop", "name"], sep: "\t")
    | collectFile






 }