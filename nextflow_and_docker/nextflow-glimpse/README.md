## download needed file

wget -c http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz{,.tbi}


CHR=22
bcftools norm -m -any CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz -Ou --threads 4 |
bcftools view -m 2 -M 2 -v snps -s ^NA12878,NA12891,NA12892 --threads 4 -Ob -o reference_panel/1000GP.chr22.noNA12878.bcf
bcftools index -f reference_panel/1000GP.chr22.noNA12878.bcf --threads 4
rm CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz*

bcftools view -G -Oz -o reference_panel/1000GP.chr22.noNA12878.sites.vcf.gz reference_panel/1000GP.chr22.noNA12878.bcf

## static path
[yanyan@ip-172-31-55-139 ~]$ ls /usr/local/bin/ | grep GLIMPSE2
GLIMPSE2_chunk_static
GLIMPSE2_concordance_static
GLIMPSE2_ligate_static
GLIMPSE2_phase_static


## upload to ec2 from local 
scp -i ~/.ssh/20220621_yanyan.pem 1000GP.chr22.noNA12878.sites.vcf.gz yanyan@54.160.117.224:/home/yanyan/glimpse2_test_temp

## run chunk 
GLIMPSE2_chunk_static --help

GLIMPSE2_chunk_static \
--input 1000GP.chr22.noNA12878.sites.vcf.gz \
--region chr22 \
--sequential \
--output chunks.chr22.txt \
--map chr22.b38.gmap.gz