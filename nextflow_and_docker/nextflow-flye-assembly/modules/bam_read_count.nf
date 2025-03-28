process BAM_READ_COUNT {

  
  input:
  tuple val(pair_id), path(bam), path(fa) 
  
  output:
  tuple val(pair_id), path("*.txt")  
  
  """
  bam-readcount -f $fa -w 0 $bam > ${pair_id}.bam.readcount.txt

  """
  
}
