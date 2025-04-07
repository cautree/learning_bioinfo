process DOWNSAMPLE {
    

     input:
      tuple val(pair_id),  path(fq) 

     output:
      tuple  val(pair_id), path('*.fastq.gz') 

     """
     if [ $params.downsample -gt 0 ]; then
      seqtk sample -s 14 ${fq} $params.downsample | gzip > ${pair_id}.${params.downsample}.fastq.gz
    
     else
      ln -s ${fq} ${pair_id}.full.fastq.gz
    
     fi
     """
}
