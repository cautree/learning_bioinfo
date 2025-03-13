

bam_ch = Channel
           .fromPath( "s3://seqwell-analysis/20241213_NextSeq2000/other_bam_for_impute/bam/*.bam" ) 
           .map {it -> tuple( it.baseName.tokenize(".")[0], it)}
           
  ref_ch =Channel
           .fromPath("s3://seqwell-ref/hg38.fa*")
           .collect()


process collect_wgs {
  
  publishDir path: 'metrics', pattern: '*.txt'
  
  input:
  tuple val(pair_id), path(bam) from bam_ch
  tuple path(ref), path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6) from ref_ch
    
  output:
  path("*.txt")
    
  
  
  """
  
  java -jar /picard.jar CollectWgsMetrics \
  VALIDATION_STRINGENCY=SILENT \
  CAP=1000000 \
  I=$bam O=${pair_id}.wgs.txt \
  R=$ref
  
  """
  
  
  
}

