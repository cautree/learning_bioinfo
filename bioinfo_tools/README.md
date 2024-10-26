

## sampling bam files
```
samtools view -s 0.01 -bh  SEQW102S013.H11.bam > SEQW102S013.H11.01.bam
```

## get sepcific chromosome from bam files
```
ls | parallel 'samtools index {}'
ls | grep -v bai | sed 's|.md.bam||' | parallel ' samtools view -b {}.md.bam chr22 > {}.chr22.bam'

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


## give bcf file names

```
ls sampled_bcf > file
while read line; do
sample_id=$(basename $line .bcf ) 
echo $sample_id > ${sample_id}.txt
bcftools reheader -s ${sample_id}.txt -o  bcf_w_sample_id/${sample_id}.bcf  sampled_bcf/$line

done < file

```



## subset chromosome from vcf files
```
bcftools view HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz --regions chr22  -Oz > test.vcf.gz



```


## bcf file view, once find the file was empty!!
```
bcffile=~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working_retry/glimpse_ligate_out/221017-purePlex24-A10.chr22_merge.bcf
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%ID]\n' $bcffile -o output.txt


truth=../truth_vcf/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%ID]\n' $truth -o truth_output.txt


bcftools view $truth

```


## filter the vcf files and keep the sites that has snps
```
bcftools view -c 1 -v snps 221017-purePlex24-F10.chr22_sampled.vcf.gz | grep -v "^#" | cut -f2 | sort -u | wc -l
44635

bcftools view -c 1 -v snps 221017-purePlex24-F10.chr22_sampled.vcf.gz  > 221017-purePlex24-F10.chr22_sampled.c1.vcf.gz
44635





ls | grep .bcf | grep -v csi | sed 's|.bcf||g' | parallel 'bcftools view  {}.bcf > {}.vcf'
ls | grep .vcf|   sed 's|.vcf||g' | parallel 'bcftools view  -c 1 -v snps {}.vcf > {}.c1.vcf'

ls | grep .c1.vcf | sed 's|.c1.vcf||g'| parallel 'bcftools sort -Oz {}.c1.vcf -o {}.c1.sorted.vcf.gz'

ls | grep gz | paralle "tabix -f -p vcf {}"

```


##snpsift environ
```
mamba activate myenvname

snpeff is in ec2 instance deepvar env
```