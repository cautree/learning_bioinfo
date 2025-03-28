process MINIMAP2 {


     input:
      tuple val(pair_id), path(fq),  path(fa) 

     output:
      tuple val(pair_id),  path("*bam"), emit:bam
      path ("*.csv"), emit: metrics

     """
     if [ -s $fa ]; then
       bwa index $fa

      minimap2 \
      -a $fa \
        $fq \
        | samtools view -bh -F2048 - \
        | samtools sort > ${pair_id}.bam

      samtools depth -a ${pair_id}.bam > ${pair_id}.depth.csv
      samtools view -c ${pair_id}.bam >${pair_id}.count.csv
     
     else
      touch ${pair_id}.depth.csv
      touch ${pair_id}.count.csv
      touch ${pair_id}.bam
     fi
     """
}
