




process spades {
  
  
  publishDir path: 'spades_out', mode: 'copy'
  
  container "staphb/spades:latest"
  
  input:
  tuple val(sample_ID),  path( fq1), path( fq2)
  
  output:
  tuple val(sample_ID),  path( "*")
  
  """
  
   spades.py -1 $fq1 -2 $fq2 -o ${sample_ID}_spades_out
  
  """
}


workflow {
  
  fq = Channel
     .fromFilePairs("fq/*_R{1,2}_001.fastq.gz", flat: true)
     
  

   spades( fq)
  
  
}
   