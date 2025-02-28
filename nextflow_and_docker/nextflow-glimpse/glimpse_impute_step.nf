
process glimpse_impute {

  publishDir path: "glimpse_impute", mode: 'copy'

  container "glimpse:v2.0.0-27-g0919952_20221207"

  input:
  tuple val(pair_id), path(bam), path(index)
  path(split_genome)
  each path(chunk_file)

  output:
  tuple val(pair_id), path("${pair_id}*vcf.gz*")

  script:
  """
  REF=1000GP.chr22.noNA12878

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

    bcftools view -Oz -o \${OUT}_\${CHR}_\${REGS}_\${REGE}.vcf.gz \${OUT}_\${CHR}_\${REGS}_\${REGE}.bcf 
    
    bcftools index --tbi \${OUT}_\${CHR}_\${REGS}_\${REGE}.vcf.gz 

  done < $chunk_file
  """
}

process ligate {
  
  publishDir path: "glimpse_ligate", mode: 'copy'

  container "glimpse:v2.0.0-27-g0919952_20221207"

  input:
  tuple val(pair_id), path(vcf)


  output:
  tuple val(pair_id), path("${pair_id}*ligated*")
  
  
  """
  
  LST=list.chr22.txt
  ls -1v | grep vcf.gz | grep -v tbi  > \${LST}

  OUT=${pair_id}_chr22_ligated.bcf
  GLIMPSE2_ligate --input \${LST} --output \$OUT

  bcftools view -Oz -o ${pair_id}.ligated.vcf.gz \$OUT
    
  bcftools index --tbi ${pair_id}.ligated.vcf.gz
  
  """
}

workflow {
  
bam_index_file_ch  =    Channel
    .fromPath('bam/*.bam')
    .map { bam_file -> 
        def index_file = bam_file + '.bai'  // Assuming index follows BAM naming convention
        def pair_id = bam_file.baseName.replace('.bam', '')  // Extract sample ID
        tuple(pair_id, bam_file, index_file)
    }
          bam_index_file_ch.view() 
  split_genome_ch =Channel.fromPath("s3://seqwell-ref/glimpse2/split_genome_chr22/*.bin").collect()
  
  chunk_file_ch = Channel.fromPath("s3://seqwell-ref/glimpse2/split_genome_chr22/chunks.chr22.txt")
  
  vcf = glimpse_impute(bam_index_file_ch, split_genome_ch, chunk_file_ch)

  ligate(vcf)
}

