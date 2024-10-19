#!/home/ec2-user/nextflow/nextflow


params.ref="chr22"


refs = Channel.fromPath("ref/" + params.ref + ".fa*")
              .collect(sort: true)

     
(fq1,fq2) = Channel
     .fromPath("bam/*.bam")
     .map{ it -> tuple( it.baseName.tokenize('.')[0] , it) }
     .take( params.dev ? params.number_of_inputs : -1 )
     .into(2)
     
    

process run_freebayes {

container "quay.io/biocontainers/freebayes:1.3.6--h346b5cb_1"

input: 
tuple val(pair_id), path(bam) from fq1
tuple path(ref), path(ref1), path(ref2), path(ref3), path(ref4), path(ref5), path(ref6) from refs

output:
path('*.vcf') into vcf_ch


"""
freebayes  -f $ref $bam -dd > ${pair_id}.vcf

"""


}



