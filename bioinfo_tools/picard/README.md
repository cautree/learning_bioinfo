
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




## java --heap space

```

 To get help, see http://broadinstitute.github.io/picard/index.html#GettingHelp
  Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
        at java.util.Arrays.copyOfRange(Arrays.java:3664)
        at java.lang.String.<init>(String.java:207)
        at java.lang.String.toUpperCase(String.java:2810)
        at java.lang.String.toUpperCase(String.java:2833)
        at picard.analysis.artifacts.CollectSequencingArtifactMetrics.getRefContext(CollectSequencingArtifactMetrics.java:305)
        at picard.analysis.artifacts.CollectSequencingArtifactMetrics.acceptRead(CollectSequencingArtifactMetrics.java:293)
        at picard.analysis.SinglePassSamProgram.makeItSo(SinglePassSamProgram.java:145)

```

## correction, set memeory
```
java -Xmx24g -jar /picard.jar CollectSequencingArtifactMetrics \
     I=${pair_id}.RG.bam \
     O=${pair_id}.artifact \
     R=$ref
     

```