#!/usr/bin/env nextflow


nextflow.enable.dsl=2

params.run = ""
params.analysis = ""

process sort_bam {
    input:
    tuple val(pair_id), path(bam)

    output:
    tuple val(pair_id),path("${pair_id}_sorted_by_readid.bam"), emit: bam
    path("*.count"),                                            emit: count1

   // publishDir path: "output", mode: 'copy'

    script:
    """
    # Sort BAM by read ID and save to specific directory with ${pair_id}_sorted_by_readid.bam
    samtools sort -n -@ 15  ${bam} -o ${pair_id}_sorted_by_readid.bam
    echo ${pair_id} >> temp
    samtools view -c -f 3 -F 4 ${bam} >> temp
    cat temp | paste - - > ${pair_id}.aligned.count
    """
}

process run_samblaster {
    input:
    tuple val(pair_id), path(sorted_bam)

    output:
    tuple val(pair_id), path("${pair_id}_samp.disc.sam"), path("${pair_id}_samp.split.sam")


//    publishDir path: "output", mode: 'copy'

    script:
    """
    # Run Samblaster and save SAM files and CSV report to specific directory
    samtools view -@ 15 -h ${sorted_bam} | samblaster -a -e -d ${pair_id}_samp.disc.sam -s ${pair_id}_samp.split.sam -o ${pair_id}chimeric_report.csv
    
    """
}

process count_reads {
  
  input:
  tuple val(pair_id), path(disc_sam), path(split_sam)
  
  output:
  path("*.count"),                         emit: count2
  
  """
  
    echo ${pair_id} >> temp
    samtools view -c ${disc_sam} >> temp
    samtools view -c ${split_sam} >> temp
    cat temp | paste - - -  > ${pair_id}.chimeric.count
    
  
  
  """
  
  
}

process convert_sam_to_fastq {
    input:
    tuple val(pair_id), path(disc_sam), path(split_sam)

    output:
    tuple path("${pair_id}.disc.*fastq"), path("${pair_id}.split.fastq"), emit: fq
    path("*.disc.bam*")

  //  publishDir path: "output", mode: 'copy'
    publishDir path: "s3://seqwell-users/yanyan/extract_chimeric/${params.run}/${params.analysis}/chimeric", pattern: '*disc*'

    script:
    """
    
    
    # Convert SAM to FASTQ and save to specific directory
    if [ -f ${disc_sam} ] && [ -s ${disc_sam} ]; then
        samtools view -bS ${disc_sam} > ${pair_id}.disc.bam
        samtools sort -o sorted.${pair_id}.disc.bam ${pair_id}.disc.bam
        
        samtools index sorted.${pair_id}.disc.bam
        bedtools bamtofastq -i ${pair_id}.disc.bam -fq ${pair_id}.disc.R1.fastq -fq2 ${pair_id}.disc.R2.fastq
    else
        echo "Warning: disc_sam file is empty, skipping conversion for ${pair_id}.disc.fastq"
    fi

    # Check if split_sam is not empty before converting to fastq
    if [ -f ${split_sam} ] && [ -s ${split_sam} ]; then
        samtools view -bS ${split_sam} > ${pair_id}.split.bam
        samtools sort -o sorted.${pair_id}.split.bam ${pair_id}.split.bam       
       
        samtools index sorted.${pair_id}.split.bam
        
        bedtools bamtofastq -i ${pair_id}.split.bam -fq ${pair_id}.split.fastq
    else
        echo "Warning: split_sam file is empty, skipping conversion for ${pair_id}.split.fastq"
    fi
    """
}


process summarize {
  
  //publishDir path: "output", mode: 'copy'
  publishDir path: "s3://seqwell-users/yanyan/extract_chimeric/${params.run}/${params.analysis}/chimeric"    
  
  input:
  path(all_txt)
  
  output:
  path("*.summary.csv")
  
  """
  cat *aligned.count > input1.txt
  cat *chimeric.count > input2.txt
  paste input1.txt input2.txt > input.txt

  echo "sample_ID,aligned_reads,chimeric_reads,chimeric_reads_ratio" >> ${params.run}.chimeric.summary.csv  
  awk '{print \$0"\t"\$4/\$2}' input.txt  |  awk ' {print \$1"\t"\$2"\t"\$4"\t"\$6 }' |  tr '\t' ',' >>  ${params.run}.chimeric.summary.csv
  
  """
  
}

workflow {
    // Example of providing inputs (pair_id and BAM file)
    chimeric_report = Channel.fromPath('s3://seqwell-analysis/' + params.run + '/' + params.analysis  + '/bam/*.md.bam') 
        .map { bam_file -> tuple(bam_file.baseName.replace('.md', ''), bam_file) }

    // Execute processes
    sorted_bam = chimeric_report | sort_bam
    samblaster_output = sorted_bam.bam | run_samblaster

    sam_output_count1= sorted_bam.count1

    // Convert SAM files to FASTQ 
    fastq_output = samblaster_output | convert_sam_to_fastq

    sam_output_count2 = count_reads(samblaster_output)
    
    sam_output_count_all = sam_output_count1.mix(sam_output_count2)
    summarize(sam_output_count_all.collect() )
}

