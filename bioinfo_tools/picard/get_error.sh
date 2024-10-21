#!/bin/bash

paste a b > file
while read input_name output_name; do 

inbam=${input_name}
outbam=${output_name}



picard=../../../../../software/picard.jar

java -jar $picard AddOrReplaceReadGroups \
      I=$inbam \
       O=$outbam \
       RGID=4 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=20


sample_id=$(basename $outbam .md.bam)
java -Xmx12g -jar $picard CollectSequencingArtifactMetrics \
     I=$outbam \
     O=${sample_id} \
     R=hg38.fa

done < file

rm file