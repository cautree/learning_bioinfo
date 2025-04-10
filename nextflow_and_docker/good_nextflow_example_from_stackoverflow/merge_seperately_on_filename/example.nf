workflow {
  files = Channel.fromPath('**.linear', checkIfExists: true)
  files
    .branch {
      TC: it.name.contains('TC')
      HDL: it.name.contains('HDL')
    }
    .set { result }
  result
    .TC
    .collectFile(name: 'TC.txt', storeDir: '/Users/mribeirodantas/sandbox')
  result
    .HDL
    .collectFile(name: 'HDL.txt', storeDir: '/Users/mribeirodantas/sandbox')
}

//https://stackoverflow.com/questions/74280156/merge-multiple-output-chunks-to-one-file-in-nextflow