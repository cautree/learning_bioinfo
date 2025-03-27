process GET_BAM_BY_CHR {
  tag "${pair_id}"
  
  input:
    tuple val(pair_id), path(bam)
  
  output:
    tuple val("${pair_id}.${params.chr}"), path("*.${params.chr}.bam"), path("*.${params.chr}.bam.bai")
  
  
  """
  samtools index $bam
  samtools view -b $bam ${params.chr} > ${pair_id}.${params.chr}.bam
  samtools index ${pair_id}.${params.chr}.bam
  """

}
