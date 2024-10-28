
//took 8 hours, 12 threads o the 64G mem ec2 instance for fastq 40*2=80 G data
process trim_reads {

container "quay.io/biocontainers/trimmomatic:0.36--3"

publishDir path: "s3://seqwell-projects/Azenta_20240814/fulcrum_75bp/fastq/"

input:

tuple val(sample_id), path(fastq1), path(fastq2)

output:
path("*")

//CROP:<length>  length: The number of bases to keep, from the start of the read. 

"""
trimmomatic PE -threads 12 $fastq1 $fastq2  \
              ${sample_id}.trimmed.R1.fastq.gz ${sample_id}un.trimmed.R1.fastq.gz \
              ${sample_id}.trimmed.R2.fastq.gz ${sample_id}un.trimmed.R2.fastq.gz \
              CROP:75

"""

}


workflow {
params.fastq_path="s3://seqwell-fastq/20210510_MiSeq-Appa/ARTIC-8-20210510_FASTQ/" 
fq = Channel
     .fromFilePairs(params.fastq_path + "*_R{1,2}_001.fastq.gz", flat: true)
     
fq.view()
     
trim_reads(fq)

}