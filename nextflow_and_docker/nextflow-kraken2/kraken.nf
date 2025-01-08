//params.reads = "$projectDir/fastq/*_R{1,2}_001.fastq.gz"
//params.reads = "$projectDir/20221010_Element_FASTQ/*_R{1,2}.fastq.gz"
//params.reads = "s3://seqwell-projects/20221010_Element/20221010_Element_FASTQ/*_R{1,2}.fastq.gz"
//params.reads = "s3://seqwell-projects/20221017_Element/20221017_Element_FASTQ/*_R{1,2}.fastq.gz"
//params.reads = "s3://seqwell-users/jsmith/20200107_Nxt_meta/*_R{1,2}_001.fastq.gz"
//params.reads = "s3://seqwell-users/jsmith/20191119_LP_meta/*_R{1,2}_001.fastq.gz"
params.reads = "s3://seqwell-users/jsmith/20191119_LP_meta/*Zymo_ref_R{1,2}_001.fastq.gz"
//params.db="$projectDir/k2-std-db/"
params.db="$projectDir/PlusPF/"
params.downsample = 2000000

process downsample {

     input:
     tuple val(pair_id), path(read1), path(read2) 

     output:
     tuple val(pair_id), path('*R1.fastq.gz'), path('*R2.fastq.gz') 

     """
     if [ $params.downsample -gt 0 ]; then
     seqtk sample -s 14 ${read1} $params.downsample | gzip > ${pair_id}.${params.downsample}_R1.fastq.gz
     seqtk sample -s 14 ${read2} $params.downsample | gzip > ${pair_id}.${params.downsample}_R2.fastq.gz
     else
     ln -s ${read1} ${pair_id}_full_R1.fastq.gz
     ln -s ${read2} ${pair_id}_full_R2.fastq.gz
     fi
     """
}


process KRAKEN {
     
     publishDir "s3://seqwell-projects/20191119_LP_meta/20191119_LP_meta_2M_Zymo", mode: "copy"
     input:
     tuple val(pair_id), path(read1), path(read2)
     val (ref)

     output:
     tuple val(pair_id), path('*report.txt'), emit: "report"
     tuple val(pair_id), path('*output.txt'), emit: "output"

     """
     
     kraken2 \
      --db $ref \
      --threads 16 \
      --memory-mapping \
      --unclassified-out ${pair_id}.unclassified#.fq \
      --classified-out   ${pair_id}.classified#.fq\
      --output ${pair_id}.output.txt \
      --report ${pair_id}.report.txt \
      --paired \
      --gzip-compressed $read1 $read2
     
     """
}



process BRAKEN_SPECIES {
     
     publishDir "s3://seqwell-projects/20191119_LP_meta/20191119_LP_meta_2M_Zymo", mode: "copy"
     
     input:
     tuple val(pair_id), path(report)
     val (ref)

     output:
     tuple val(pair_id), path('*bracken.species.txt') 

     """
    bracken \
    -d ${ref} \
    -i $report \
    -o ${pair_id}.bracken.species.txt \
    -r 150 \
    -l S \
    -t 0
     
     """
}



process BRAKEN_GENUS {
     
     publishDir "s3://seqwell-projects/20191119_LP_meta/20191119_LP_meta_2M_Zymo", mode: "copy"
     
     input:
     tuple val(pair_id), path(report)
     val (ref)

     output:
     tuple val(pair_id), path('*bracken.genus.txt') 

     """
    bracken \
    -d ${ref} \
    -i $report \
    -o ${pair_id}.bracken.genus.txt \
    -r 150 \
    -l G \
    -t 0
     
     """
}



read_chl = Channel
    .fromFilePairs(params.reads,  flat: true)

workflow {

// read_chl.view()

  read_chl_1 = downsample(read_chl)
 
  kraken = KRAKEN(read_chl_1, params.db)
  
  report_chl = kraken.report

  BRAKEN_SPECIES(report_chl, params.db )
  BRAKEN_GENUS(report_chl, params.db )
}