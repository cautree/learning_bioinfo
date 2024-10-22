#!/home/ec2-user/nextflow/nextflow

params.plate = "210616-ecoli-i7LP_FASTQ"
params.outfile = "20210617_NextSeq_ecoli_10k_i7-LP"
params.ref = "ecoli_REL606"

work_dir = file(workflow.workDir).toString()
params.run = work_dir.split('/')[-3] 
params.analysis = work_dir.split('/')[-2]

assert work_dir.split('/')[-1] == "work"

refs = Channel.fromPath("s3://seqwell-ref/" + params.ref + ".fa*")
              .collect()

params.downsample = 0
params.wgs = false
params.artifact = false
params.crosstalk = false

params.dev = false
params.number_of_inputs = 4

if(params.dev) { 
   path_s3 = "seqwell-dev/analysis"
} else { 
   path_s3 = "seqwell-analysis"
}

fq = Channel
     .fromFilePairs("s3://seqwell-fastq/" + params.run + "/{" + params.plate + "}/*_R{1,2}_001.fastq.gz", flat: true)
     .take( params.dev ? params.number_of_inputs : -1 )

// downsample fastq
process downsample {

     input:
     tuple val(pair_id), path(read1), path(read2) from fq

     output:
     tuple val(pair_id), path('*_R1_001.fastq.gz'), path('*_R2_001.fastq.gz') into sample_fq

     """
     if [ $params.downsample -gt 0 ]; then
     seqtk sample -s 14 ${read1} $params.downsample | gzip > ${pair_id}.${params.downsample}_R1_001.fastq.gz
     seqtk sample -s 14 ${read2} $params.downsample | gzip > ${pair_id}.${params.downsample}_R2_001.fastq.gz
     else
     ln -s ${read1} ${pair_id}_full_R1_001.fastq.gz
     ln -s ${read2} ${pair_id}_full_R2_001.fastq.gz
     fi
     """
}


// bwa align fastq to reference
process bwa {

//     publishDir path: 'bam', pattern: '*.bam'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/bam"

     input:
     tuple val(pair_id), path(read1), path(read2) from sample_fq
     tuple path(ref), path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6) from refs

     output:
     tuple val(pair_id), path('*.bam') into bam_ch

     """
     bwa mem -t $task.cpus $ref $read1 $read2 | samtools view -bh -F2048 - | samtools sort > ${pair_id}.bam
     """
}


// picard mark duplicates
process markDuplicates {

//     publishDir path: 'bam', pattern: '*.bam'
     publishDir path: 'metrics', pattern: '*.txt'

     publishDir path: "s3://$path_s3/$params.run/$params.analysis/bam", pattern: '*.bam'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/metrics", pattern: '*.txt'

     input:
     tuple val(pair_id), path(bam) from bam_ch

     output:
     tuple val(pair_id), path('*.md.bam') into md
     tuple val(pair_id), path('*.md.bam') into md2
     file '*.txt' into md_metrics

     """
     java -jar /picard.jar MarkDuplicates \
       VALIDATION_STRINGENCY=SILENT \
       OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 \
       I=$bam \
       O=${pair_id}.md.bam \
       M=${pair_id}.md.txt
     """
}

// picard metrics
process picardMetrics {

     publishDir path: 'metrics', pattern: '*.txt'
     publishDir path: 'figures', pattern: '*.pdf'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/metrics", pattern: '*.txt'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/figures", pattern: '*.pdf'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/metrics", pattern: '*artifact*'

     input:
     tuple val(pair_id), path(bam) from md
     tuple path(ref), path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6) from refs

     output:
     file '*.txt' into metrics
     path '*.pdf' into figures
     path '*.csv' into csvs
     path '*artifact.error_metrics' into artifact

     """
     
     java -jar /picard.jar CollectMultipleMetrics \
      VALIDATION_STRINGENCY=SILENT \
      I=$bam \
      O=$pair_id \
      R=$ref \
      PROGRAM=null \
      PROGRAM=CollectAlignmentSummaryMetrics \
      PROGRAM=CollectGcBiasMetrics \
      PROGRAM=CollectInsertSizeMetrics

     mv ${pair_id}.alignment_summary_metrics ${pair_id}.align.txt
     mv ${pair_id}.gc_bias.detail_metrics ${pair_id}.GC.txt
     mv ${pair_id}.gc_bias.pdf ${pair_id}.GC.pdf
     mv ${pair_id}.gc_bias.summary_metrics ${pair_id}.GC_sum.txt
     if [ -f ${pair_id}.insert_size_metrics ]; then
     	mv ${pair_id}.insert_size_metrics ${pair_id}.insert.txt
     	mv ${pair_id}.insert_size_histogram.pdf ${pair_id}.insert.pdf
     else
     	touch ${pair_id}.insert.txt
     	touch ${pair_id}.insert.pdf
     fi

     cat ${pair_id}.GC.txt | tail -n 104 | head -n 102 | cut -f3,6,7 | sed 's/\t/,/g' > ${pair_id}.GC.csv
     cat ${pair_id}.insert.txt | awk 'NR > 10' | cut -d. -f1 | sed 's/\t/,/g' > ${pair_id}.insert.csv

     if $params.wgs; then
     java -jar /picard.jar CollectWgsMetrics VALIDATION_STRINGENCY=SILENT CAP=1000000 I=$bam O=${pair_id}.wgs.txt R=$ref
     fi
     
     if $params.artifact; then
     java -jar /picard.jar AddOrReplaceReadGroups \
      I=$bam \
       O=${pair_id}.RG.bam \
       RGID=4 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=20
     
     java -Xmx24g -jar /picard.jar CollectSequencingArtifactMetrics \
     I=${pair_id}.RG.bam \
     O=${pair_id}.artifact \
     R=$ref
     
     cat ${pair_id}.artifact.error_summary_metrics  | grep -v "#"  > ${pair_id}.artifact.error_metrics
     
     
     
     fi
     """
}

all_metrics = metrics.toList().concat(md_metrics.toList()).toList().flatten().toList()
other_outputs = csvs.toList().flatten().toList()
artifact_outputs = artifact.toList().flatten().toList()

// summarize 
process summarize {

     stageInMode 'copy'
     publishDir path: '.', mode: 'copy', overwrite: true
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/"

     input:
     file files from all_metrics
     file outputs from other_outputs

     output:
     path '*.xlsx' into summary
     path '*.zip' into zips
     path '*.insert.csv' into histograms

     """
     mkdir -p ${params.outfile}_GCbins
     mkdir -p ${params.outfile}_insertbins    
     cp *GC.csv ${params.outfile}_GCbins
     cp *insert.csv ${params.outfile}_insertbins
     zip ${params.outfile}_GCbins.zip ${params.outfile}_GCbins/*
     zip ${params.outfile}_insertbins.zip ${params.outfile}_insertbins/*

     combine_metrics.py ${params.outfile}.xlsx
     combine_csvs.py ${params.outfile}
     """
}

// get counts by chromosome for crosstalk analysis
process counts {

     publishDir path: 'counts'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/counts"

     input:
     tuple val(pair_id), path(bam) from md2

     output:
     path '*.idxstats' into counts

     when:
     params.crosstalk

     """
     samtools index $bam
     samtools idxstats $bam > ${pair_id}.idxstats
     """
}

// summarize counts of chomosomes
all_counts = counts.toList().flatten().toList()

process summarizeCounts {

     stageInMode 'copy'
     publishDir path: '.', mode: 'copy', overwrite: true
     publishDir path: "s3://$path_s3/$params.run/$params.analysis"

     input:
     file files from all_counts

     output:
     path '*.csv' into summary_counts

     when:
     params.crosstalk

     """
     summarize_counts.py ${params.outfile}.counts.csv
     """
}


process summarizeArtifacts {
  
  
     publishDir path: '.', mode: 'copy', overwrite: true
     publishDir path: "s3://$path_s3/$params.run/$params.analysis"

     input:
     file files from artifact_outputs

     output:
     path '*.csv' 

     when:
     params.artifact

     """
     summarize_artifacts.py ${params.outfile}.artifact.error_summary_metrics.csv
     """
  
  
  
}