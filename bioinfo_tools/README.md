

## sampling bam files
```
samtools view -s 0.01 -bh  SEQW102S013.H11.bam > SEQW102S013.H11.01.bam
```

## get sepcific chromosome from bam files
```
samtools view -b input.bam chr22 >output.bam
```



## gatk to validate the format of vcf/bcf files
```
docker run  \
-u $(stat -f "%u:%g" ${HOME}) \
-v $(pwd):$(pwd) -w $(pwd) \
broadinstitute/gatk:latest gatk ValidateVariants \
   -R reference_genome/hs38DH.chr22.fa.gz \
   -V NA12878_GLIMPSE_impute/NA12878_imputed_chr22_37020561_43204202.vcf \
   --validation-type-to-exclude ALL
   
   
   docker run  \
-u $(stat -f "%u:%g" ${HOME}) \
-v $(pwd):$(pwd) -w $(pwd) \
broadinstitute/gatk:latest gatk ValidateVariants \
   -R reference_genome/hs38DH.chr22.fa.gz \
   -V NA12878_GLIMPSE_impute/NA12878_imputed_chr22_37020561_43204202.bcf \
   --validation-type-to-exclude ALL

```



bcftools index
```
#https://github.com/samtools/bcftools/issues/668
bcftools view file.vcf -Oz -o file.vcf.gz
bcftools index file.vcf.gz
```