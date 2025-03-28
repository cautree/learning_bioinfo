process CIRCLATOR_MINIMUS2 {
  
  input:
   tuple val(pair_id), path(fasta)
  
  output:
    tuple val(pair_id), path("*circularise.fasta"), emit: fasta
    path("*info.csv"), emit: csv
  
  """
  circlator minimus2 $fasta ${pair_id}
  echo  "${pair_id}"  > id
  cat ${pair_id}.log |  grep "circularised:"  | cut -d' ' -f3 | sed 's/^ *//' > circularised
  cat ${pair_id}.circularise.fasta | grep -v '>' | wc  | tr -s ' ' | sed 's/^ *//' | cut -d' ' -f3 > length
  paste id length circularised | sed 's/^ *//' | tr '\t' ',' | sed 's/,,/,/g' > ${pair_id}.info.csv
  
  """
}


