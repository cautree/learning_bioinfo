


process extract_reads {
  
    publishDir path: "s3://seqwell-analysis/20250221_MiSeq-Appa/aign/short_insert_reads"


    tag "$pair_id"

    input:
    tuple val(pair_id), path(bam)

    output:
    path "${pair_id}.fastq"


    script:
    """
    samtools view -h $bam | awk 'substr(\$0,1,1) == "@" || (\$9 >= 18 && \$9 <= 150)' | \
        samtools view -b - > filtered.bam
    
    samtools sort -n filtered.bam -o filtered_sorted.bam
    samtools fastq -n filtered_sorted.bam > ${pair_id}.fastq
    """
}
//20250214_MiSeq-Sharkboy

bam_ch = Channel.fromPath("s3://seqwell-analysis/20250221_MiSeq-Appa/aign/bam/*.md.bam")
         .map{ it -> tuple( it.baseName.tokenize(".")[0], it)}

workflow{
  
  extract_reads(bam_ch)
  
}


