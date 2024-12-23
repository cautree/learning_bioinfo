
#test successful
nextflow run nf-core/phaseimpute -r dev -profile test,docker --outdir nf_phase_test_out -resume


~/Documents/projects/20241008_eremid/nf-core/phaseimpute/tests/csv/panel_full.csv \


nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "GRCh38" \
--tools "glimpse2" \
--panel panel.csv \
--steps "panelprep" \
--input samplesheet/sample_bam.csv



nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "GRCh38" \
--tools "glimpse2" \
--panel panel.csv \
--steps "impute" \
--input samplesheet/sample_bam.csv \
--chunks chunks.csv



##is other species working?
nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "TAIR10" \
--tools "glimpse2" \
--panel panel.csv \
--steps "impute" \
--input ../test_nf_impute/samplesheet/sample_bam.csv \
--chunks ../test_nf_impute/chunks.csv


## downsample to 1x, can only be integer
```
nextflow run nf-core/phaseimpute \
    --input samplesheet_sim/sample_bam.csv  \
    --steps simulate \
    --depth 1 \
    --outdir depth_2_simulated \
    --fasta reference_genome/chr22.fa \
    -profile docker -r dev \
    -resume -bg
    
```


## genome prep

```
#create posfile, this does not work

nextflow run nf-core/phaseimpute \
--input samplesheet_input_2_samples.csv \
--panel panel.csv \
-resume -bg \
--steps panelprep --outdir panel_prep_results \
--genome GRCh38 -profile docker \
-r dev \
--compute_freq

```


## validation, this does not work
```
nextflow run nf-core/phaseimpute \
    --input samplesheet_input.csv \
    --input_truth samplesheet_truth.csv \
    --posfile posfile.csv \
    --steps validate \
    --outdir validation_results \
    --genome GRCh38 \
    -profile docker \
    -r dev 

```


## validation, this works

```

https://odelaneau.github.io/GLIMPSE/docs/documentation/concordance/
/home/ec2-user/software/GLIMPSE2/GLIMPSE2_concordance_static

use the glimpse2_static file



#ERROR: No sample in common between datasets
bcftools query -l HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz
bcftools query -l C1003C03depth1x.vcf.gz
bcftools reheader -s samples.txt -o a.vcf.gz C1003C03depth1x.vcf.gz
mv a.vcf.gz C1003C03depth1x.vcf.gz
bcftools index C1003C03depth1x.vcf.gz


echo "chr22 1000GP.chr22.noNA12878.sites.vcf.gz HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz C1003C03depth1x.vcf.gz" > concordance.txt

/home/ec2-user/software/GLIMPSE2/GLIMPSE2_concordance_static \
--gt-val \
--ac-bins 1 5 10 20 50 100 200 500 1000 2000 5000 10000  20000 50000 100000 140119 \
--threads 2 \
--input concordance.txt \
--output concordance_c20_rp140


```


##############################################
# write a bash file for many files
#############################################
#!/bin/bash
#for num in {1..176}; do
#echo "chr22 ../test/1000GP.chr22.noNA12878.sites.vcf.gz ../test/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz" >> concordance_a.txt
#done
#ls vcf | grep vcf.gz | grep -v csi | sed 's|^|vcf/|'  > concordance_b.txt
#paste concordance_a.txt concordance_b.txt > concordance.txt
#cat concordance_b.txt  | cut -d. -f1 | cut -d/ -f2 | sed 's|^|,|' > name
#paste concordance.txt name > info
#cat info | tr '\t' ' ' > a
#mv a info
while read line; do 
part1=$(echo $line | cut -d, -f1)
echo ${part1} > input_concordance.txt
part2=$(echo $line | cut -d, -f2)
echo ${part2}
/home/ec2-user/software/GLIMPSE2/GLIMPSE2_concordance_static \
--gt-val \
--input input_concordance.txt \
--ac-bins 1 5 10 20 50 100 200 500 1000 2000 5000 10000  20000 50000 100000 140119 \
--threads 2 \
--output ${part2}.concordance_c20_rp140

done < info





https://git.wur.nl/derks047/skimseq_imputation/-/blob/master/compare/glimpse2/results/1.concordance.rsquare.grp.txt

#####################################
#steps to run concordance using the glimpse2 static file
####################################
1) change the vcf file names otherwise #ERROR: No sample in common between datasets
samples.txt include the sample name for the reference
cat samples.txt
HG001
```
#!/bin/bash
ls | grep vcf.gz > file
while read line; do
bcftools reheader -s samples.txt -o a.vcf.gz $line
mv a.vcf.gz $line
bcftools index $line
done < file
rm file
```

2) run concordance for many samples using the bash scripts below

```
#!/bin/bash
#for num in {1..176}; do
#echo "chr22 ../test/1000GP.chr22.noNA12878.sites.vcf.gz ../test/HG001_GRCh38_1_22_v4.2.1_benchmark.chr22.vcf.gz" >> concordance_a.txt
#done
#ls vcf | grep vcf.gz | grep -v csi | sed 's|^|vcf/|'  > concordance_b.txt
#paste concordance_a.txt concordance_b.txt > concordance.txt
#cat concordance_b.txt  | cut -d. -f1 | cut -d/ -f2 | sed 's|^|,|' > name
#paste concordance.txt name > info
#cat info | tr '\t' ' ' > a
#mv a info
while read line; do 
part1=$(echo $line | cut -d, -f1)
echo ${part1} > input_concordance.txt
part2=$(echo $line | cut -d, -f2)
echo ${part2}
/home/ec2-user/software/GLIMPSE2/GLIMPSE2_concordance_static \
--gt-val \
--input input_concordance.txt \
--bins 0.00000 0.01000 0.02000 0.05000 0.10000 0.20000 0.30000 0.40000 0.50000 \
--thread 4 \
--output ${part2}.concordance_MA_bins
done < info
```
