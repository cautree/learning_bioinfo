
##################################
#A07
##################################
fq1=../../invertion_detection/fastq_of_3_groups/A4002_A07_R1_001.fastq.gz
fq2=../../invertion_detection/fastq_of_3_groups/A4002_A07_R2_001.fastq.gz


fq=$fq1
id=A07
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R1.fastq \
maskmiddle=f \
overwrite=t \
kmask=lc \
ref=$fa k=30 hdist=0 stats=${id}.R1.stats.txt

fq=$fq2
id=A07
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R2.fastq \
maskmiddle=f \
overwrite=t \
kmask=lc \
ref=$fa k=30 hdist=0 stats=${id}.R2.stats.txt



##################################
#A07
##################################
fq1=../../invertion_detection/fastq_of_3_groups/A4002_G09_R1_001.fastq.gz
fq2=../../invertion_detection/fastq_of_3_groups/A4002_G09_R2_001.fastq.gz
fq=$fq1
id=G09
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R1.fastq \
maskmiddle=f \
overwrite=t \
ref=$fa k=30 hdist=0 stats=${id}.R1.stats.txt

fq=$fq2
id=G09
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R2.fastq \
maskmiddle=f \
overwrite=t \
ref=$fa k=30 hdist=0 stats=${id}.R2.stats.txt



fq1=../../invertion_detection/fastq_of_3_groups/A4002_H09_R1_001.fastq.gz
fq2=../../invertion_detection/fastq_of_3_groups/A4002_H09_R2_001.fastq.gz
fq=$fq1
id=H09
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R1.fastq \
maskmiddle=f \
overwrite=t \
ref=$fa k=30 hdist=0 stats=${id}.R1.stats.txt

fq=$fq2
id=H09
../../../../../software/bbmap/bbduk.sh in=$fq \
out=${id}.unmatched.fastq outm=${id}.matched.R2.fastq \
maskmiddle=f \
overwrite=t \
ref=$fa k=30 hdist=0 stats=${id}.R2.stats.txt














