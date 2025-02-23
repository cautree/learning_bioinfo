#!/bin/bash


ls | grep vcf.gz | grep -v csi | wc -l > count
for num in {1..$count}; do
echo "chr22 s3://seqwell-ref/vcf/1000GP.chr22.noNA12878.sites.vcf.gz s3://seqwell-ref/vcf/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz" >> reference.txt
done

ls |  grep vcf.gz | grep -v tbi | grep -v chr22 > vcf_file.txt

paste reference.txt vcf_file.txt > files
cat vcf_file  | cut -d. -f1 | cut -d/ -f2 | sed 's|^|,|' > name
paste files name > info

while read line; do 
part1=$(echo $line | cut -d, -f1)
part2=$(echo $line | cut -d, -f2)
echo ${part1} > input_concordance.txt
echo ${part2}

/home/ec2-user/software/GLIMPSE2/GLIMPSE2_concordance_static \
--gt-val \
--input input_concordance.txt \
--bins 0.00000 0.001 0.01000 0.02000 0.05000 0.10000 0.20000 0.30000 0.40000 0.50000 \
--thread 4 \
--output ${part2}.concordance_c20_rp140

done < info


s3://seqwell-analysis/20250117_NextSeq2000/glimpse2/impute/imputation/glimpse2/samples/1001200nMA011x.vcf.gz