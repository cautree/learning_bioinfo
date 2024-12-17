
https://github.com/bwa-mem2/bwa-mem2

spin an aws instance that has 120G, and index hg38.no_alt.fa


#########################
# test the aligner difference of bwa mem and bwa-mem2
#########################

https://github.com/bwa-mem2/bwa-mem2

in kraken instance

/home/ec2-user/bwa-mem2-2.2.1_x64-linux/bwa-mem2 index ecoli_REL606.fa
read1=fq/PB207_H12_R1_001.fastq.gz
read2=fq/PB207_H12_R2_001.fastq.gz
/home/ec2-user/bwa-mem2-2.2.1_x64-linux/bwa-mem2 mem ecoli_REL606.fa $read1 $read2  |   samtools view -bh -F2048 - | samtools sort > PB207_H12.mem2.bam

read1=../fq/PB207_H12_R1_001.fastq.gz
read2=../fq/PB207_H12_R2_001.fastq.gz
bwa mem ecoli_REL606.fa $read1 $read2  |   samtools view -bh -F2048 - | samtools sort > PB207_H12.mem1.bam


bam=PB207_H12.mem1.bam
ref=ecoli_REL606.fa
java -jar /home/ec2-user/software/picard.jar CollectAlignmentSummaryMetrics \
I=$bam \
O=PB207_H12.mem1 \
R=$ref 


bam=PB207_H12.mem2.bam
ref=ecoli_REL606.fa
java -jar /home/ec2-user/software/picard.jar CollectAlignmentSummaryMetrics \
I=$bam \
O=PB207_H12.mem2 \
R=$ref 


