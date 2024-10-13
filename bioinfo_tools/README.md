

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


## gatk
```
[October 12, 2024 at 11:46:13 PM GMT] org.broadinstitute.hellbender.tools.walkers.validation.Concordance done. Elapsed time: 0.01 minutes.
Runtime.totalMemory()=98566144
***********************************************************************

A USER ERROR has occurred: Cannot read file:///Users/yanyan/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow/glimpse_sample_out/115M_zac_E02.chr22.01_sampled.bcf because no suitable codecs found

***********************************************************************

```

## correction: change bcf files to vcf
```
bcftools view sample.bcf > sample.vcf
```