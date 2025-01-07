

params.plate = "Watchmaker_FASTQ"
params.outfile = "Watchmaker_out"
params.ref = "hg38.no_alt"


params.run = "20241108_NextSeq2000" 
params.analysis = "hc"

refs = Channel.fromPath("s3://seqwell-ref/" + params.ref + ".fa*")
              .collect()

params.downsample = 0
params.wgs = false
params.hybrid = true
params.crosstalk = false
params.artifact = false
params.mosdepth_coverage_bin_width = 500
params.mosdepth_coverage_thresholds = "20,30"
params.targets = "NO_FILE"



params.dev = false
params.number_of_inputs = 1

if(params.dev) { 
   path_s3 = "seqwell-dev/analysis"
} else { 
   path_s3 = "seqwell-analysis"
}

if(params.hybrid) {
//  refs = refs.concat(Channel.fromPath("s3://seqwell-ref/panels/twist*intervals"))
//             .collect()
//  refs = refs.concat(Channel.fromPath("s3://seqwell-ref/panels/xgen-exome-hyb*no_alt.intervals"))
//             .collect()
    refs = refs.concat(Channel.fromPath("s3://seqwell-ref/panels/twist*no_alt.intervals"))
               .collect()
}


refs.view()

fq = Channel
     .fromFilePairs("s3://seqwell-fastq/" + params.run + "/{" + params.plate + "}/*_R{1,2}_001.fastq.gz", flat: true, checkIfExists:true)
     .take( params.dev ? params.number_of_inputs : -1 )
     
     
read_files_fastqc = Channel
                    .fromFilePairs("s3://seqwell-fastq/" + params.run + "/{" + params.plate + "}/*_R{1,2}_001.fastq.gz", size:1, checkIfExists:true)
                    .take( params.dev ? params.number_of_inputs : -1 )

target_ch = Channel.fromPath(params.targets).first()
                    
process fastqc {
    
    input:
    set val(name), file(reads) from read_files_fastqc
 
    output:
    file "*_fastqc.{zip,html}" into fastqc_results
 
    script:
    """
    fastqc -q $reads
    """
}
     

// downsample fastq
process downsample_bbtools {

     input:
     tuple val(pair_id), path(read1), path(read2) from fq

     output:
     tuple val(pair_id), path('*_R1_001.fastq.gz'), path('*_R2_001.fastq.gz') into sample_fq

     """
     if [ $params.downsample -gt 0 ]; then
     
     /usr/local/bbmap/reformat.sh \
     -Xmx60G \
     in1=$read1 \
     in2=$read2 \
     out1=${pair_id}.${params.downsample}_R1_001.fastq.gz \
     out2=${pair_id}.${params.downsample}_R2_001.fastq.gz \
     samplereadstarget=${params.downsample} \
     sampleseed=13

     
     else
     ln -s ${read1} ${pair_id}_full_R1_001.fastq.gz
     ln -s ${read2} ${pair_id}_full_R2_001.fastq.gz
     fi
     
     """
}


// bwa align fastq to reference
process bwa {

//    publishDir path: 'bam', pattern: '*.bam'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/bam"

     input:
     tuple val(pair_id), path(read1), path(read2) from sample_fq
     path ref from refs

     output:
     tuple val(pair_id), path('*.bam') into bam_ch

     """
     bwa mem -t $task.cpus ${ref[0]} $read1 $read2 | samtools view -bh -F2048 - | samtools sort > ${pair_id}.bam
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
     tuple val(pair_id), path('*.md.bam') into md3
     tuple val(pair_id), path('*.md.bam') into md4
     file '*.txt' into md_metrics

     """
     java -Xmx60g -jar /picard.jar MarkDuplicates \
       VALIDATION_STRINGENCY=SILENT \
       OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 \
       I=$bam \
       O=${pair_id}.md.bam \
       M=${pair_id}.md.txt
     """
}

process index_mdbam {
  
  publishDir path: "s3://$path_s3/$params.run/$params.analysis/bam", pattern: '*.bai'
  
  input:
     tuple val(pair_id), path(bam) from md3
  
  output:
     tuple val(pair_id), path("*.bai") into index_ch
     
  """
  samtools index $bam
  
  """
  
  
}



bam_index_ch = md4.join(index_ch)


process MOSDEPTH {
    tag "${sample_id}"
   // publishDir "mosdepth_out", mode: 'copy'


    input:
    tuple val(sample_id), path(bam), path(index) from bam_index_ch
    path(targets) from target_ch

    output: 
    path("*.bed.gz")
    path("*.mosdepth.*.txt") into mos_out

    script:
    def intervals = targets.name != 'NO_FILE' ? targets : params.mosdepth_coverage_bin_width
    """
    mosdepth \\
        --threads ${task.cpus} \\
        --by ${intervals} \\
        --thresholds ${params.mosdepth_coverage_thresholds} \\
        ${bam.getBaseName()} \\
        ${bam}
    """

    
}








// picard metrics
process picardMetrics {

     publishDir path: 'metrics', pattern: '*.txt'
     publishDir path: 'figures', pattern: '*.pdf'
     publishDir path: 'targets', pattern: '*.targets' 
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/metrics", pattern: '*.txt'
     publishDir path: "s3://$path_s3/$params.run/$params.analysis/figures", pattern: '*.pdf'
  //   publishDir path: "s3://$path_s3/$params.run/$params.analysis/targets", pattern: '*.targets'

     input:
     tuple val(pair_id), path(bam) from md
     path ref from refs

     output:
     path '*.txt' into metrics
     path '*.pdf' into figures
     path '*.csv' into csvs
//     path '*targets' into targets
     file '*.txt' into metrics2
     file '*.txt' into metrics3

     """
     java -Xmx60g -jar /picard.jar CollectMultipleMetrics \
      VALIDATION_STRINGENCY=SILENT \
      I=$bam \
      O=$pair_id \
      R=${ref[0]} \
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
     java -Xmx60g  -jar /picard.jar \
       CollectWgsMetrics \
       VALIDATION_STRINGENCY=SILENT \
       CAP=1000000 \
       I=$bam \
       O=${pair_id}.wgs.txt \
       R=${ref[0]}
     fi

     if $params.hybrid; then
     java -Xmx60g -jar /picard.jar \
       CollectHsMetrics \
       VALIDATION_STRINGENCY=SILENT \
       I=$bam \
       O=${pair_id}.hybrid.txt \
       R=${ref[0]} \
       BAIT_INTERVALS=${ref[-2]} \
       TARGET_INTERVALS=${ref[-1]} \
       COVERAGE_CAP=1000000 \
       NEAR_DISTANCE=250 \
       PER_TARGET_COVERAGE=${pair_id}.coverage.targets
     fi
     
     
     if $params.artifact; then
     java -Xmx60g -jar /picard.jar AddOrReplaceReadGroups \
      I=$bam \
       O=${pair_id}.RG.bam \
       RGID=4 \
       RGLB=lib1 \
       RGPL=ILLUMINA \
       RGPU=unit1 \
       RGSM=20
     
     java -Xmx60g -jar /picard.jar CollectSequencingArtifactMetrics \
     I=${pair_id}.RG.bam \
     O=${pair_id}.artifact \
     R=${ref[0]}
     
     cat ${pair_id}.artifact.error_summary_metrics  | grep -v "#"  > ${pair_id}.artifact.error_metrics.txt
     
     fi
     
     
     """
}

all_metrics = metrics.toList().concat(md_metrics.toList()).toList().flatten().toList()
other_outputs = csvs.toList().flatten().toList()

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




all_metrics2=metrics2.collect()
process summarizeArtifacts {
  
  
     //publishDir path: '.', mode: 'copy', overwrite: true
     publishDir path: "s3://$path_s3/$params.run/$params.analysis"

     input:
     file files from all_metrics2

     output:
     path '*.csv' 

     when:
     params.artifact

     """
     summarize_artifacts.py ${params.outfile}.artifact.csv
     """
  
  
  
}



all_metrics_output = mos_out.mix( metrics3 ).mix( fastqc_results).collect()



process MULTIQC {
  
   // publishDir "mosdepth_out", mode: 'copy'
    publishDir path: "s3://$path_s3/$params.run/$params.analysis/MosDepth" , mode: 'copy'

    input:
    path(qc_files) from all_metrics_output

    output:
    path("*.html"), emit: report

    script:
    def datetime = new Date().format("yyyy-MM-dd_HH-mm-ss", TimeZone.getTimeZone("UTC"))
    def filename = datetime + "_multiqc_report.html"
    """
    # Ignore FASTQC in the general summary table because duplication rate is a poor estimate
    # Ignore mosdepth in the general summary table because bases >=30x seems incorrect
    # Ignore Picard HsMetrics in the general summary table because it is optional
    multiqc   \\
        --cl-config 'table_columns_visible: { FastQC: False, mosdepth: False }' \\
        --cl-config 'fn_clean_exts: [".downsampled", ".duplicate_metrics", ".markdup", ".marked", ".umi-grouped", ".md"]' \\
        --filename ${filename} \\
        --force \\
        --interactive \\
        --no-data-dir \\
        --verbose \\
        ./
    """

  
}
