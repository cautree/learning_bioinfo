process GLIMPSE2_LIGATE {

  input:
   tuple val(pair_id), path(bcf)

  output:
   tuple val(pair_id), path("${pair_id}*ligated.bcf*")
  
  """
  
  LST=list.${params.chr}.txt
  ls -1v | grep bcf | grep -v csi   > \${LST}

  OUT=${pair_id}_${params.chr}_ligated.bcf
  GLIMPSE2_ligate --input \${LST} --output \$OUT

  
  """
}

