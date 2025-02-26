
process fix_start {
  
  container "sangerpathogens/circlator"
  
  input:
  tuple(pair_id), path(fa)
  
  output:
  path("*.fa")
  
  """
  circlator fixstart $fa  ${pair_id}.correctStart.fa

  """
}



workflow {
  
  fa_ch = channel.fromPath("*.fasta")
                  .map{ it -> tuple( it.baseName.tokenize(".")[0], it)}
  fix_start(fa_ch)
  
}