process GLIMPSE2_PHASE {
  publishDir path: 'phase_output', mode: 'copy'  
  input:
  tuple val(pair_id), path(bam), path(index)
  path(split_genome)
  each path(chunk_file)

  output:
  tuple val(pair_id), path("${pair_id}*bcf*")

  script:
  """
  REF=1000GP.${params.chr}.noNA12878

  while IFS="" read -r LINE || [ -n "\$LINE" ]; do
    # Extract values from the LINE
    ID=\$(printf "%02d" \$(echo \$LINE | cut -d" " -f1))
    IRG=\$(echo \$LINE | cut -d" " -f3)
    ORG=\$(echo \$LINE | cut -d" " -f4)
    CHR=\$(echo \$LINE | cut -d" " -f2)
    
    # Extract regions (start and end of the chromosome segment)
    REGS=\$(echo \$IRG | cut -d":" -f 2 | cut -d"-" -f1)
    REGE=\$(echo \$IRG | cut -d":" -f 2 | cut -d"-" -f2)

    # Output file name using pair_id and chromosome info
    OUT=${pair_id}

    # Run GLIMPSE2 phase command with the extracted parameters
    GLIMPSE2_phase --bam-file $bam --reference \${REF}_\${CHR}_\${REGS}_\${REGE}.bin --output \${OUT}_\${CHR}_\${REGS}_\${REGE}.bcf

  done < $chunk_file
  """
}

