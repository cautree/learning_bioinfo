params.target_depth = [0.1, 0.2, 0.5, 1, 2]
params.chr = "chr22"
params.run = "20250302_Admera_Health"
params.analysis = "hg38_align"
params.human_genome = "HG001"

include { DOWNSAMPLE } from './modules/downsample.nf'
include { GLIMPSE2_PHASE } from './modules/phase.nf'
include { GLIMPSE2_LIGATE } from './modules/ligate.nf'
include { GET_BAM_BY_CHR } from './modules/get_bam_by_chr.nf'
include { BCF_REHEADER } from './modules/reheader_bcf.nf'
include { GLIMPSE2_CONCORDANCE } from './modules/glimpse_concordance.nf'
include { GET_C1_BCF } from './modules/get_c1_bcf.nf'
include { GATK_CONCORDANCE } from './modules/GATK_concordance.nf'
include { COLLECT_GLIMPSE2_CONCORDANCE } from './modules/collect_glimpse2_concordance.nf'
include { COLLECT_GATK_CONCORDANCE } from './modules/collect_gatk_concordance.nf'


workflow {
  
   bam_ch = Channel.fromPath( "s3://seqwell-analysis/"  + params.run + "/" + params.analysis + "/bam/*.md.bam")
                   .map{ it-> tuple(it.baseName.tokenize(".")[0] , it)}
                   .take(2)
   bam_by_chr = GET_BAM_BY_CHR( bam_ch )
   
   target_depths = Channel.fromList(params.target_depth)
    
    
   bam_by_chr_depth =  bam_by_chr
                       .combine(target_depths) // Creates all pairwise combinations of BAM files and target depths
        
   bam_by_chr_depth.view()                   
   downsampled_bam = DOWNSAMPLE( bam_by_chr_depth )
   
   split_genome_ch =Channel.fromPath("genome_prep/1000GP." + params.chr + "*.bin").collect()
  
   chunk_file_ch = Channel.fromPath("genome_prep/chunks." +  params.chr + ".txt")
  
   bcf = GLIMPSE2_PHASE(downsampled_bam, split_genome_ch, chunk_file_ch)
  
   ligated_bcf = GLIMPSE2_LIGATE(bcf)  

   reheaded_bcf = BCF_REHEADER( ligated_bcf)
   
   sites_ch = channel.fromPath("s3://seqwell-ref/vcf/1000GP." +  params.chr + ".noNA12878.sites.vcf.gz")
   truth_vcf_ch = Channel.fromPath("s3://seqwell-ref/vcf/"+ params.human_genome + "_GRCh38_1_22_v4.2.1_benchmark." + params.chr + ".vcf.gz{,.csi}").collect()
   
   reheaded_bcf.view()
   sites_ch.view()
   truth_vcf_ch.view()   
   glimpse2_concordance_ch =  GLIMPSE2_CONCORDANCE(reheaded_bcf, sites_ch, truth_vcf_ch)

   c1_bcf_ch = GET_C1_BCF(ligated_bcf)

   ref_ch = Channel.fromPath("s3://seqwell-ref/" + params.chr + "*").collect()
   truth_vcf_ch = Channel.fromPath("s3://seqwell-ref/vcf/" + params.human_genome + "_GRCh38_1_22_v4.2.1_benchmark." + params.chr + ".vcf.gz*").collect()
   
      
   gatk_concordance_ch = GATK_CONCORDANCE( ref_ch,truth_vcf_ch, c1_bcf_ch)
   
   COLLECT_GATK_CONCORDANCE(gatk_concordance_ch.collect())
   COLLECT_GLIMPSE2_CONCORDANCE(glimpse2_concordance_ch.collect())

}


