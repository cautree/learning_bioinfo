process GLIMPSE2_SPLIT {
  publishDir path: 'genome_prep', mode: 'copy'   
  
  input:
    path(REF)
    path(MAP)
    path(chunk)
  
  output:
    path("*")
  
  """

  while IFS="" read -r LINE || [ -n "\$LINE" ];
    do
    printf -v ID "%02d" \$(echo \$LINE | cut -d" " -f1)
    IRG=\$(echo \$LINE | cut -d" " -f3)
    ORG=\$(echo \$LINE | cut -d" " -f4)

    GLIMPSE2_split_reference --reference ${REF} --map ${MAP} --input-region \${IRG} --output-region \${ORG} --output 1000GP.${params.chr}.noNA12878
  done < $chunk
  
  """
  
  
}
