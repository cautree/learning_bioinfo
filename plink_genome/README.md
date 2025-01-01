
##merge vcf file

```
#https://www.biocomputix.com/post/combining-multiple-vcf-bcf-files-using-bcftools-concat
ls ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out/*.bcf  

mkdir sampled_bcf 
mkdir bcf_w_sample_id
cp ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out/*.bcf sampled_bcf
ls sampled_bcf > file
while read line; do
sample_id=$(basename $line .bcf ) 
echo $sample_id > ${sample_id}.txt
bcftools reheader -s ${sample_id}.txt -o  bcf_w_sample_id/${sample_id}.bcf  sampled_bcf/$line

done < file

bcftools query -l bcf_w_sample_id/SEQW102S013.A11.chr22_sampled.bcf


ls bcf_w_sample_id  | parallel 'bcftools  index -f bcf_w_sample_id/{}'


bcftools merge bcf_w_sample_id/*.bcf \
--threads 8 -Oz -o merged_bcf/SEQW102S013.vcf.gz 

tabix -fp vcf merged_bcf/SEQW102S013.vcf.gz 
```



```
VCF=merged_bcf/SEQW102S013.vcf.gz
plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out pacbio
```


```

plink --vcf $VCF --double-id --allow-extra-chr \
--extract pacbio.prune.in \
--make-bed --pca --out pacbio
```

## plot PCA
```

value_df = read.table("nextseq.1x.eigenval")
total = sum(value_df$V1)
pc1 = 100*(value_df$V1[[1]]/total)
pc2 = 100*(value_df$V1[[2]]/total)


ret_pca=read.table("nextseq.1x.eigenvec")
ret_pca
ret_pca = ret_pca %>% 
  dplyr::mutate( group = ifelse( grepl("C(01|02|03|04)", V2), "HG001", "HG005")) %>% 
  dplyr::mutate( group = as.factor(group))

ret_pca %>% 
  ggplot(aes(V3, V4, colour = group)) +
  geom_point() +
  xlab("PC1:83.7% variance explained") +
  ylab("PC2:3.3% variance explained")

```


##this is for get the relatedness using plink genome

```
VCF=merged_bcf/SEQW102S013.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr --indep-pairwise 50 10 0.1 --out pacbio_mpileup
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract pacbio_mpileup.prune.in \
--recode transpose \
--out pacbio_mpileup 

/Users/yanyan/Documents/software/plink_mac_20221210/plink --tfile pacbio_mpileup --genome --out pacbio_mpileup --allow-extra-chr
```



























##########################
# old
#########################

s3://seqwell-analysis/20221216_NextSeq2000/impute/merge/soy_impute-vcf-merged.vcf.gz

bcftools query -l filtered_maize.vcf.gz
tabix -fp vcf maize_impute-vcf-merged.vcf.gz
bcftools view -Oz -s 221219-BioEcho-Zea-mays-B02-20000000,221219-BioEcho-Zea-mays-C02-20000000,221219-BioEcho-Zea-mays-D02-20000000,221219-BioEcho-Zea-mays-E02-20000000,221219-BioEcho-Zea-mays-F02-20000000,221219-BioEcho-Zea-mays-G02-20000000,221219-BioEcho-Zea-mays-H02-20000000,221219-BioEcho-Zea-mays-A03-20000000,221219-BioEcho-Zea-mays-B03-20000000 maize_impute-vcf-merged.vcf.gz --force-samples > filtered_maize.vcf.gz



bcftools view -Oz -s 221219-BioEcho-Zea-mays-B06-20000000,221219-BioEcho-Zea-mays-C06-20000000,221219-BioEcho-Zea-mays-D06-20000000,221219-BioEcho-Zea-mays-E06-20000000,221219-BioEcho-Zea-mays-F06-20000000,221219-BioEcho-Zea-mays-G06-20000000,221219-BioEcho-Zea-mays-H06-20000000,221219-BioEcho-Zea-mays-A07-20000000,221219-BioEcho-Zea-mays-B07-20000000 maize_impute-vcf-merged.vcf.gz --force-samples > filtered_maize_2.vcf.gz


tabix -fp vcf soy_impute-vcf-merged.vcf.gz
bcftools view -Oz -s 221219-BioEcho-Glycine-max-A01-10000000,221219-BioEcho-Glycine-max-B01-10000000,221219-BioEcho-Glycine-max-C01-10000000,221219-BioEcho-Glycine-max-D01-10000000,221219-BioEcho-Glycine-max-E01-10000000,221219-BioEcho-Glycine-max-F01-10000000,221219-BioEcho-Glycine-max-G01-10000000,221219-BioEcho-Glycine-max-H01-10000000,221219-BioEcho-Glycine-max-A02-10000000 soy_impute-vcf-merged.vcf.gz --force-samples > filtered_soy.vcf.gz



tabix -fp vcf soy_impute-vcf-merged.vcf.gz
bcftools view -Oz -s 221219-BioEcho-Glycine-max-A05-10000000,221219-BioEcho-Glycine-max-B05-10000000,221219-BioEcho-Glycine-max-C05-10000000,221219-BioEcho-Glycine-max-D05-10000000,221219-BioEcho-Glycine-max-E05-10000000,221219-BioEcho-Glycine-max-F05-10000000,221219-BioEcho-Glycine-max-G05-10000000,221219-BioEcho-Glycine-max-H05-10000000,221219-BioEcho-Glycine-max-A06-10000000 soy_impute-vcf-merged.vcf.gz --force-samples > filtered_soy_2.vcf.gz



tabix -fp vcf tomato_impute-vcf-merged.vcf.gz
bcftools view -Oz -s 221219-BioEcho-Solanum-lycopersicum-C03-7600000,221219-BioEcho-Solanum-lycopersicum-D03-7600000,221219-BioEcho-Solanum-lycopersicum-E03-7600000,221219-BioEcho-Solanum-lycopersicum-F03-7600000,221219-BioEcho-Solanum-lycopersicum-G03-7600000,221219-BioEcho-Solanum-lycopersicum-H03-7600000,221219-BioEcho-Solanum-lycopersicum-A04-7600000,221219-BioEcho-Solanum-lycopersicum-B04-7600000,221219-BioEcho-Solanum-lycopersicum-C04-7600000 tomato_impute-vcf-merged.vcf.gz --force-samples > filtered_tomato.vcf.gz


VCF=filtered_tomato.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out tomato

VCF=filtered_tomato.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract tomato.prune.in \
--make-bed --pca --out tomato







VCF=filtered_soy.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out soy

/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract soy.prune.in \
--make-bed --pca --out soy



VCF=filtered_maize.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out maize


/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract maize.prune.in \
--make-bed --pca --out maize 






VCF=filtered_soy_2.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out soy2

/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract soy2.prune.in \
--make-bed --pca --out soy2



VCF=filtered_maize_2.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out maize2


/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract maize2.prune.in \
--make-bed --pca --out maize2


VCF=filtered_maize_12.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out maize12


/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract maize12.prune.in \
--make-bed --pca --out maize12



VCF=filtered_soy_12.vcf.gz
/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--indep-pairwise 50 10 0.1 --out soy12


/Users/yanyan/Documents/software/plink_mac_20221210/plink --vcf $VCF --double-id --allow-extra-chr \
--extract soy12.prune.in \
--make-bed --pca --out soy12
