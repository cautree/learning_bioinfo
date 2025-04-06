process get_reads_stats {
    tag "${pair_id}"

    input:
    tuple val(pair_id), path(fq)

    output:
    tuple val(pair_id), path("${pair_id}.read_length_stats.csv")

    script:
    """
    zcat ${fq} | awk 'NR%4==2 {print length(\$0)}' | sort -n > read_lengths.txt

    awk -v pair_id=${pair_id} '
    BEGIN {
        sum=0;
    }
    {
        len[NR]=\$1;
        sum+=\$1;
    }
    END {
        n=NR;
        min=len[1];
        max=len[n];
        mean=sum/n;

        if (n%2==1) {
            median=len[(n+1)/2];
        } else {
            median=(len[n/2] + len[n/2+1])/2;
        }

        q1_index=int(n*0.25);
        if (q1_index<1) q1_index=1;
        q3_index=int(n*0.75);
        if (q3_index<1) q3_index=1;

        q1=len[q1_index];
        q3=len[q3_index];

        print "pair_id,min,max,mean,median,q1,q3" > "'${pair_id}.read_length_stats.csv'";
        print pair_id","min","max","mean","median","q1","q3 >> "'${pair_id}.read_length_stats.csv'";
    }' read_lengths.txt
    """
}

