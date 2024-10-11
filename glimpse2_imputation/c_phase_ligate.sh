#!/bin/bash



#$1: NA12878_1x_bam/NA12878.bam
BAM=$1
sample_id=$(basename $BAM .bam)


#######################################
#impute GLIMPSE2_phase
#######################################

mkdir -p ${sample_id}_GLIMPSE_impute

REF=reference_panel/split/1000GP.chr22.noNA12878


while IFS="" read -r LINE || [ -n "$LINE" ]; 
do   
	printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
	IRG=$(echo $LINE | cut -d" " -f3)
	ORG=$(echo $LINE | cut -d" " -f4)
	CHR=$(echo ${LINE} | cut -d" " -f2)
	REGS=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f1)
	REGE=$(echo ${IRG} | cut -d":" -f 2 | cut -d"-" -f2)
	OUT=${sample_id}_GLIMPSE_impute/${sample_id}_imputed
	
	docker run  \
	-u $(stat -f "%u:%g" ${HOME}) \
	-v $(pwd):$(pwd) -w $(pwd) \
	glimpse:v2.0.0-27-g0919952_20221207 \
	GLIMPSE2_phase \
	--bam-file ${BAM} \
	--reference ${REF}_${CHR}_${REGS}_${REGE}.bin \
	--output ${OUT}_${CHR}_${REGS}_${REGE}.vcf
done < chunks.chr22.txt



######################################
# ligate
######################################

ls ${sample_id}_GLIMPSE_impute | \
grep vcf | sed 's|.vcf||g' | \
parallel "bcftools view ${sample_id}_GLIMPSE_impute/{}.vcf -Oz -o ${sample_id}_GLIMPSE_impute/{}.vcf.gz"

ls ${sample_id}_GLIMPSE_impute | \
grep vcf.gz | \
parallel "bcftools index -c ${sample_id}_GLIMPSE_impute/{}"




mkdir -p ${sample_id}_GLIMPSE_ligate
LST=${sample_id}_GLIMPSE_ligate/list.chr22.txt
ls -1v ${sample_id}_GLIMPSE_impute/${sample_id}_*.vcf.gz > ${LST}

OUT=${sample_id}_GLIMPSE_ligate/chr22_ligated.vcf


docker run  \
-u $(stat -f "%u:%g" ${HOME}) \
-v $(pwd):$(pwd) -w $(pwd) \
glimpse:v2.0.0-27-g0919952_20221207 \
GLIMPSE2_ligate \
--input ${LST} \
--output $OUT

