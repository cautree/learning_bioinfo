


## change bcf to bcf and bgzip

sample1=221017-purePlex24-A10.chr22_sampled.c1.vcf
sample2=SEQW102S013.A11.chr22_sampled.c1.vcf

bgzip -c $sample1 > 221017-purePlex24-A10.chr22_sampled.c1.vcf.gz
bgzip -c $sample2 > SEQW102S013.A11.chr22_sampled.c1.vcf.gz

## bcftools stats
sample1a=221017-purePlex24-A10.chr22_sampled.c1.vcf.gz
sample2a=SEQW102S013.A11.chr22_sampled.c1.vcf.gz
bcftools index $sample1a
bcftools index $sample2a
bcftools stats $sample1a $sample2a > joined.A.stats.txt

## bedtools intersect
bedtools intersect -u -a $sample1a -b $sample2a | wc -l ## 37495 overlaps

##jaccard index
bedtools jaccard -a $sample1a -b $sample2a


## reference
### https://samtools.github.io/bcftools/bcftools-man.html#isec
### https://www.reddit.com/r/bioinformatics/comments/5jqqsj/comparing_variants_from_two_vcfs/
### https://davetang.org/muse/2019/09/02/comparing-vcf-files/


bcftools isec $sample1a $sample2a -p isec

# no private variants for sample1a
cat isec/0000.vcf | grep -v "^#" | wc -l
8031
 
# no private variants for sample2a
cat isec/0001.vcf | grep -v "^#" | wc -l
4194
 
# shared variants by both
cat isec/0002.vcf | grep -v "^#" | wc -l
37488
 
# shared variants by both
cat isec/0003.vcf | grep -v "^#" | wc -l
37488