#!/usr/local/bin/nextflow

REFVCF_chl = Channel.fromPath("../reference_panel/1000GP.chr22.noNA12878.sites.vcf.gz")
REFTSV_chl = Channel.fromPath("../reference_panel/1000GP.chr22.noNA12878.sites.tsv.gz")
REFGEN_chl = Channel.fromPath("../reference_genome/chr22.fa")
REFMAP_chl = Channel.fromPath("../maps/chr22.b38.gmap.gz")
REFBCF_chl = Channel.fromPath("../reference_panel/1000GP.chr22.noNA12878.bcf")
REFBCF_csi_chl = Channel.fromPath("../reference_panel/1000GP.chr22.noNA12878.bcf.csi")



bam_ch_0 = Channel.fromPath("../../imputation_test/bam/*.bam")
               .map{ file -> tuple( file.baseName.replace(".bam", ""), file) }



process SORT_INDEX {

input:
tuple val(pair_id), path(bam)


output:
tuple val(pair_id), path("*_sorted.md.bam"), path("*_sorted.md.bam.bai")


"""
samtools sort $bam > ${pair_id}_sorted.md.bam
samtools index ${pair_id}_sorted.md.bam

"""

}



process MPILEUP {

tag "$pair_id"

publishDir path: "mpileup", mode: "copy"

input:
tuple val(pair_id), file(bam), file(bai)

each path(REFVCF)
each path(REFTSV)
each path(REFGEN)

output:
tuple val(pair_id), path("*mpileup"), emit: mpileup
tuple val(pair_id), path("*mpileup.csi"), emit: mpileup_csi

"""

bcftools mpileup \
 -f $REFGEN -I -E \
 -a 'FORMAT/DP' \
 -T $REFVCF \
 -r chr22 $bam \
 -Ou | bcftools call \
 -Aim -C alleles -T $REFTSV \
 -Oz -o ${pair_id}.mpileup
 
bcftools index -f ${pair_id}.mpileup


"""



}


workflow {
  
  bam_ch = SORT_INDEX(bam_ch_0 )
  MPILEUP( bam_ch, REFVCF_chl, REFTSV_chl, REFGEN_chl )
  
  
  
}