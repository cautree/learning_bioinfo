
workflow {

   Channel.fromPath("data/intervals.bed")
   | splitCsv(header: ['chr', 'start', 'stop', 'name'], sep: '\t')
   | collectFile( entry -> [ "${entry.name}.bed", entry*.value.join("\t")  ])
   | view


}