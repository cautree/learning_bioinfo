# nf core glimpse2 imputation



## 1 step1: run the nf-simulate in the ec2 instance, save the data into the instance also in the nf impuate directory

## 2 step2: create the samplesheet for simulate low depth data

```
#!/bin/bash

path=$1
bam_folder_path=${path}/bam

ls $bam_folder_path | grep bam | grep bai > index_list
ls $bam_folder_path | grep bam |  grep -v bai > bam_list


cat bam_list | sed -E 's/\.bam$//; s/[-_.]//g'  > sample_id

while read index; do
echo ${bam_folder_path}/$index >> index_column
done < index_list

while read bam; do
echo ${bam_folder_path}/$bam >> bam_column
done < bam_list



echo sample,file,index > sample_bam_header
paste sample_id bam_column index_column | tr '\t' ',' >sample_bam_content
cat sample_bam_header sample_bam_content | grep -v bamlist > sample_bam.csv
rm bam_column index_column sample_bam_header sample_bam_content bam_list index_list sample_id
mkdir -p samplesheet
cat sample_bam.csv
mv sample_bam.csv samplesheet


```

## 3 step3 source activate /home/yanyan/.conda/envs/nf_env

## 4 step4 nf-core simulate 2x 1x 0.5x 0.2x 0.1x

mkdir simulated_bam
```

#!/bin/bash

chr=$1
depth=$2

nextflow run phaseimpute \
    --input samplesheet/sample_bam.csv  \
    --steps simulate \
    --depth $depth \
    --outdir depth_simulated \
    --fasta reference_genome/chr${chr}.fa \
    -profile docker  \
    -resume -bg

mv depth_simulated/simulation/samples/* simulated_bam
cd simulated_bam rm *csi
ls | parallel 'samtools index {}'

```

## 5 create tsamplesheet for imputation

```

#!/bin/bash


bam_folder_path=${PWD}/simulated_bam

ls $bam_folder_path | grep bam | grep bai > index_list
ls $bam_folder_path | grep bam |  grep -v bai > bam_list


cat bam_list | sed -E 's/\.bam$//; s/[-_.]//g'  > sample_id

while read index; do
echo ${bam_folder_path}/$index >> index_column
done < index_list

while read bam; do
echo ${bam_folder_path}/$bam >> bam_column
done < bam_list



echo sample,file,index > sample_bam_header
paste sample_id bam_column index_column | tr '\t' ',' >sample_bam_content
cat sample_bam_header sample_bam_content | grep -v bamlist > sample_bam_impute.csv
rm bam_column index_column sample_bam_header sample_bam_content bam_list index_list sample_id
cat sample_bam_impute.csv
mkdir -p  samplesheet
mv sample_bam_impute.csv samplesheet


```

# 6 step6, do the imputation

```

#!/usr/bin/bash


outdir="NA12878_chr22"
samplesheet="sample_bam_impute.csv"
run=test
human_genome=HG001

nextflow run phaseimpute  -profile docker \
-c /home/yanyan/glimpse2-nf-analysis/common/nextflow.config \
--outdir nf_phase_out_${outdir} \
-resume -bg \
--genome "GRCh38" \
--tools "glimpse2" \
--panel /home/yanyan/glimpse2-nf-analysis/common/panel_chr22.csv \
--steps "impute" \
--input samplesheet/${samplesheet} \
--chunks /home/yanyan/glimpse2-nf-analysis/common/chunks_chr22.csv

aws s3 sync nf_phase_out_${outdir}/imputation/glimpse2/samples/  s3://seqwell-users/yanyan/glimpse2-impute/$run/$human_genome/

```

# 7 do concordance


