
##CollectSequencingArtifactMetrics
```
inbam=UDI-SET1_G10.md.bam
outbam=UDI-SET1_G10_w_RG.md.bam

samtools view -H $bam | grep '^@RG'
picard=../../../software/picard.jar

java -jar $picard AddOrReplaceReadGroups \
      I=$inbam \
       O=$outbam \
       RGID=4 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=20



java -jar $picard CollectSequencingArtifactMetrics \
     I=$outbam \
     O=artifact_metrics.txt \
     R=ecoli_REL606.fasta
```