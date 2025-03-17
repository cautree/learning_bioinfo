



samtools view sorted.24300FL-03-01-04_S4_L003.disc.bam | awk '$7 != "=" {print $3,$7}' | sort | uniq -c > discordant_pairs.txt


{
    echo -e "Total discordant reads:\t$(samtools view -c sorted.24300FL-03-01-04_S4_L003.disc.bam)"
    echo "Chromosome distribution:"
    samtools view sorted.24300FL-03-01-04_S4_L003.disc.bam | awk '{print $3}' | sort | uniq -c | sort -nr
    echo "Inter-chromosomal mapping:"
    samtools view sorted.24300FL-03-01-04_S4_L003.disc.bam | awk '$7 != "=" {print $3,$7}' | sort | uniq -c | sort -nr
    echo "Insert size distribution:"
    samtools view sorted.24300FL-03-01-04_S4_L003.disc.bam | awk '{print $9}' | awk '{if($1>0) print $1}' | sort -n | awk '{count++; sum+=$1} END {print "Mean:",sum/count, "Total:", count}'
} > discordant_report.txt



