#!/bin/bash

#############################
#chunk
#############################
docker run  -u $(stat -f "%u:%g" ${HOME}) \
-v $(pwd):$(pwd) -w $(pwd)  \
glimpse:v2.0.0-27-g0919952_20221207 \
GLIMPSE2_chunk --input reference_panel/1000GP.chr22.noNA12878.sites.vcf.gz \
               --region chr22 \
               --sequential \
               --output chunks.chr22.txt \
               --map maps/chr22.b38.gmap.gz



#############################
#split reference
############################

mkdir -p reference_panel/split


REF=reference_panel/1000GP.chr22.noNA12878.bcf
MAP=maps/genetic_maps.b38/chr22.b38.gmap.gz


while IFS="" read -r LINE || [ -n "$LINE" ]; 
do   
	printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
	IRG=$(echo $LINE | cut -d" " -f3)
	ORG=$(echo $LINE | cut -d" " -f4)


	docker run  \
	-u $(stat -f "%u:%g" ${HOME}) \
	-v $(pwd):$(pwd) -w $(pwd) \
	glimpse:v2.0.0-27-g0919952_20221207 \
	GLIMPSE2_split_reference --reference $REF \
	                         --map $MAP \
	                         --input-region ${IRG} \
	                         --output-region ${ORG} \
	                         --output reference_panel/split/1000GP.chr22.noNA12878
	
done < chunks.chr22.txt



