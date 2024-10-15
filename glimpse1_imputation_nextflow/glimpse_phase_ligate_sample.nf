#!/usr/local/bin/nextflow




REFVCF_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.sites.vcf.gz")
REFTSV_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.sites.tsv.gz")
REFGEN_chl = Channel.fromPath("reference_genome/chr22.fa")
REFMAP_chl = Channel.fromPath("maps/chr22.b38.gmap.gz")
REFBCF_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.bcf")
REFBCF_csi_chl = Channel.fromPath("reference_panel/1000GP.chr22.noNA12878.bcf.csi")



process GLIMPSE_PHASE {

publishDir path: "glimpse_phase_out/${pair_id}", mode: "copy"


input:
    
tag "$pair_id"
    
tuple val(pair_id), path (mpileup_ch), path (csi_ch)
each path(REFBCF)
each path(REFBCF_csi)
each path(REFMAP)
each path(chunk)

output:
tuple val(pair_id), path("*imputed.bcf"), emit: bcf_files
tuple val(pair_id), path("*.bcf.list"), emit: bcf_list

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
 
 ls | grep imputed.bcf > ${pair_id}.bcf.list
 
"""


}



process INDEX_IMPUTED_BCF {

publishDir path: "glimpse_phase_out/${pair_id}", mode: "copy"

input:
tuple val(pair_id), file(imputed_bcf)
    

output:
tuple val(pair_id), file("*")

"""
ls $imputed_bcf | parallel 'bcftools index -f {}'

"""

}




process GLIMPSE_LIGATE {

publishDir path: "glimpse_ligate_out", mode: "copy"

input:
tuple val(pair_id), file(impute_list), path(bcfs), path(bcfs_index)


output:
tuple val(pair_id),file("*merge.bcf")

"""

GLIMPSE_ligate --input $impute_list --output ${pair_id}_merge.bcf

"""


}



process INDEX_MERGED_BCF {

publishDir path: "glimpse_ligate_out", mode: "copy"

input:
tuple val(pair_id), file(merge_bcf)

output:
tuple val(pair_id), path("*")


"""

bcftools index -f $merge_bcf

"""
}




process GLIMPSE_SAMPLE {

publishDir path: "glimpse_sample_out", mode: "copy"


input:
tuple val(pair_id), file(merge_bcf), file(merge_bcf_index)

output:
tuple val(pair_id), file("*")


"""
GLIMPSE_sample --input $merge_bcf --solve --output ${pair_id}_sampled.bcf

"""


}















params.chunk_sheet= "chunk.txt"

workflow {
  
chunks =Channel
    .fromPath(params.chunk_sheet)


mpileup_ch = Channel.fromPath("mpileup_out/*.mpileup" )
             .map{ file -> tuple(file.baseName , file)} 
             
         
csi_ch = Channel.fromPath("mpileup_out/*.mpileup.csi" )
        .map{ file -> tuple(file.baseName.replace(".mpileup","") , file)} 
             
    
mpileup_csi_ch = mpileup_ch.join(csi_ch)
             

phase_chl = GLIMPSE_PHASE( mpileup_csi_ch,  REFBCF_chl,REFBCF_csi_chl, REFMAP_chl, chunks)
bcf_list_ch = phase_chl.bcf_list
bcf_file_ch = phase_chl.bcf_files




index_ch = INDEX_IMPUTED_BCF(bcf_file_ch)

bcf_file_list_index = bcf_list_ch
                      .join( index_ch)
                      .join( bcf_file_ch)
                      
                      
ligate_ch=  GLIMPSE_LIGATE( bcf_file_list_index )                    
ligate_index_ch = INDEX_MERGED_BCF(ligate_ch)

ligate_sample_index_ch  = ligate_ch
                          .join(ligate_index_ch)

sample_ch = GLIMPSE_SAMPLE(ligate_sample_index_ch)
sample_ch.view()


}



