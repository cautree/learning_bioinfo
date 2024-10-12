#!/usr/local/bin/nextflow




REFVCF_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.sites.vcf.gz")
REFTSV_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.sites.tsv.gz")
REFGEN_chl = Channel.fromPath("reference_genome/chr22.fa")
REFMAP_chl = Channel.fromPath("maps/chr22.b38.gmap.gz")
REFBCF_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.bcf")
REFBCF_csi_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.bcf.csi")



process GLIMPSE_PHASE {

publishDir path: "glimpse_phase", mode: "copy"
publishDir path: "s3://seqwell-dev/analysis/20221010_Element_ALIGN_10M/glimpse/phase_update", mode: "copy"


input:
    
tag "$pair_id"
    
tuple val(pair_id), path (mpileup_ch), path (csi_ch)
each path(REFBCF)
each path(REFBCF_csi)
each path(REFMAP)
each path(chunk)

output:
path("*imputed.bcf")

"""
while read index input output; do 

GLIMPSE_phase \
 --input $mpileup_ch \
 --reference $REFBCF \
 --map $REFMAP \
 --input-region \$input \
 --output-region \$output \
 --output ${pair_id}_\${index}_imputed.bcf \
 --thread 8
 
 done < $chunk
 
"""


}



process INDEX_IMPUTED_BCF {

publishDir path: "glimpse_phase", mode: "copy"
publishDir path: "s3://seqwell-dev/analysis/20221010_Element_ALIGN_10M/glimpse/phase_update", mode: "copy"

input:
file(imputed_bcf)
    

output:
file("*")

"""
bcftools index -f $imputed_bcf

"""

}



params.chunk_sheet= "chunk.txt"

workflow {
  
chunks =Channel
    .fromPath(params.chunk_sheet)


mpileup_ch = Channel.fromPath("mpileup/*.mpileup" )
             .map{ file -> tuple(file.baseName , file)} 
             
         
csi_ch = Channel.fromPath("mpileup/*.mpileup.csi" )
        .map{ file -> tuple(file.baseName.replace(".mpileup","") , file)} 
             
    
mpileup_csi_ch = mpileup_ch.join(csi_ch)
             

phase_chl = GLIMPSE_PHASE( mpileup_csi_ch,  REFBCF_chl,REFBCF_csi_chl, REFMAP_chl, chunks)
phase_chl_all = phase_chl.flatten()


INDEX_IMPUTED_BCF(phase_chl_all)

}



