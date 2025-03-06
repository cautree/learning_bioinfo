## download needed file

wget -c http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz{,.tbi}



bcftools view -s ^NA12878,NA12891,NA12892 -Oz -o chr22_no_NA12878.vcf.gz CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz


CHR=22
bcftools norm -m -any CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz -Ou --threads 4 |
bcftools view -m 2 -M 2 -v snps -s ^NA12878,NA12891,NA12892 --threads 4 -Ob -o reference_panel/1000GP.chr22.noNA12878.bcf
bcftools index -f reference_panel/1000GP.chr22.noNA12878.bcf --threads 4
rm CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz*

CCDG_14151_B01_GRM_WGS_2020-08-05_chr22.filtered.shapeit2-duohmm-phased.vcf.gz

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

### this is somehow wrong
GLIMPSE2_chunk_static \
--input 1000GP.chr22.noNA12878.sites.vcf.gz \
--region chr22 \
--sequential \
--output chunks.chr22.txt \
--map chr22.b38.gmap.gz

0       chr22   chr22:1-17316413        chr22:1-16916453        2.50023 6397131 112891  53045
1       chr22   chr22:15649863-19744259 chr22:16916454-19317119 7.03184 2400620 45498   22701
2       chr22   chr22:18822972-22009002 chr22:19317120-21320593 6.11088 2003430 48056   22733
3       chr22   chr22:20920506-23720755 chr22:21320594-23320712 4.63175 2000074 56215   25355
4       chr22   chr22:22812019-25886271 chr22:23320713-25320836 4.1718  2000078 51703   26135
5       chr22   chr22:24920849-27720972 chr22:25320837-27320901 6.46103 2000015 47830   23347
6       chr22   chr22:26920879-31880098 chr22:27320902-29778638 3.35296 2457714 50399   22701
7       chr22   chr22:27802719-33259462 chr22:29778639-32604255 2.50087 2825577 59890   27656
8       chr22   chr22:32204267-35447923 chr22:32604256-34635448 3.2084  2031150 47870   22701
9       chr22   chr22:33768931-37186864 chr22:34635449-36786677 4.05752 2151180 49864   22701
10      chr22   chr22:36317843-39469373 chr22:36786678-38921723 4.29218 2134992 49487   22701
11      chr22   chr22:38258240-43270139 chr22:38921724-42481363 2.50009 3559599 75579   32382
12      chr22   chr22:39706677-44881437 chr22:42481364-44481438 4.33028 2000004 51375   24658
13      chr22   chr22:44081491-47049795 chr22:44481439-46481520 5.52752 2000000 54231   26131
14      chr22   chr22:46058225-48881722 chr22:46481521-48481718 5.65115 2000142 57504   27803
15      chr22   chr22:48081696-1248956422       chr22:48481719-1248956422       7.81185 2326098 71442   35404


## get the glimpse2 official docker

wget https://github.com/odelaneau/GLIMPSE/releases/download/v2.0.0/glimpse_v2.0.0-27-g0919952_20221207.tar.gz
docker load < glimpse_v2.0.0-27-g0919952_20221207.tar.gz
glimpse:v2.0.0-27-g0919952_20221207



### use chunk.nf this is correct


0       chr22   chr22:1-17396005        chr22:1-16395989        5.87671 5876713 98100   45601
1       chr22   chr22:15395989-21628520 chr22:16395995-20628436 4.23244 4232441 93236   45601
2       chr22   chr22:19628445-25628740 chr22:20628517-24628536 4.00002 4000019 104241  49009
3       chr22   chr22:23628543-29727863 chr22:24628595-28727858 4.09926 4099263 95180   45601
4       chr22   chr22:27727972-34350708 chr22:28728002-33350694 4.62269 4622692 97928   45601
5       chr22   chr22:32350694-38441639 chr22:33350720-37441617 4.0909  4090897 98146   45601
6       chr22   chr22:36441558-43351033 chr22:37441618-42350980 4.90936 4909362 105252  45601
7       chr22   chr22:41351004-47351044 chr22:42351007-46351015 4.00001 4000008 104404  50138
8       chr22   chr22:45351025-50807843 chr22:46351022-50807843 4.45682 4456821 133347  65396




## local, using static does not work

REF=1000GP.chr22.noNA12878.bcf
MAP=chr22.b38.gmap.gz
while IFS="" read -r LINE || [ -n "$LINE" ];
do
  printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
  IRG=$(echo $LINE | cut -d" " -f3)
  ORG=$(echo $LINE | cut -d" " -f4)

  GLIMPSE2_split_reference_static --reference ${REF} --map ${MAP} --input-region ${IRG} --output-region ${ORG} --output reference_panel/split/1000GP.chr22.noNA12878
done < chunks.chr22.txt



## use split_ref.nf nextflow