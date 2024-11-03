# check reads with mutiple ME to see if it aligns correctly

samtools view   ../problem_subsample_bc1001.hifi.bam |  awk '{print $10}'  >  problem_reads

## view reads with more than one ME in the first 200bp
cat problem_reads | awk '{print substr($1, 1,200) }' | grep "AGATGTGTATAAGAGACAG" 

## find the reads with this seq
seq=TCAGATGTGTATAAGAGACAGGATCTACACCAAGGACATTTCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCGATAGTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG

samtools view   ../problem_subsample_bc1001.hifi.bam | grep $seq

## find the read name is "m84092_240608_002438_s3/213847574/ccs"

## in the merged aligned problem reads, find which genome this read aligned to
readname=m84092_240608_002438_s3/213847574/ccs
samtools view problem_subsample_bc1001.md.bam | grep $readname

## view aligned bam
$ samtools view problem_subsample_bc1001.md.bam | grep $readname
m84092_240608_002438_s3/213847574/ccs   0       NC_000964.3     299149  60      164S336=1D2026=1D1297=1D5472=   *       0       9134    TAATGATACGGCGACCACCGAGATCTACACCAAGGACATTTCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGATCTACACCAAGGACATTTCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCGATAGTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGATAAACCTCAATTTCAGGGTGAAACGTTT

## understand the CIGAR, S means softclip
https://timd.one/blog/genomics/cigar.php
164S336=1D2026=1D1297=1D5472= 

## NC_000964.3 is Bacillus subtilis

## check to see if the reads exist in the demux reads that belong to Bacillus subtilis

(base) [ec2-user@ip-172-31-3-91 E_well]$ samtools view bc1001_E.bam | grep m84092_240608_002438_s3/213847574/ccs
m84092_240608_002438_s3/213847574/ccs   4       *       0       255     *       *       0       0       GATCTACACCAAGGACATTTCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCGATAGTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGATAAACCTCAATTTCAGGGTGAAACGTTTATCCACAATCTCAAAAAAGTAGATAAGCTGAAAGCAGTAGCGGAGGAAAAACAAGCGGATACGGCACATGTCGCCTTGGCGTGGCTGTTAACGAGACCGGCGATTGATGCCATTATTCCAGGAGCTAAACGACCGGAGCAATTACAGGATAACCTGAAAACCTTGAACATTGAACTGACCGAAGATGAAGTGAATTTCATCAGCGACAT


 samtools fixmate – fills in mate coordinates and insert size fields.
 ```
samtools fixmate \\
        -@ ${task.cpus} \\
        -O BAM \\
        -m \\
        in.bam \\
        out.bam"

#-r option
#-r           Remove unmapped reads and secondary alignments


 ```