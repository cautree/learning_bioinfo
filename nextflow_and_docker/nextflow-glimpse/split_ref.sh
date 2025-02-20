REF=1000GP.chr22.noNA12878.bcf
MAP=chr22.b38.gmap.gz
while IFS="" read -r LINE || [ -n "$LINE" ];
do
  printf -v ID "%02d" $(echo $LINE | cut -d" " -f1)
  IRG=$(echo $LINE | cut -d" " -f3)
  ORG=$(echo $LINE | cut -d" " -f4)

  /home/ec2-user/software/GLIMPSE2/GLIMPSE2_split_reference_static \
  --reference ${REF} \
  --map ${MAP} \
  --input-region ${IRG} \
  --output-region ${ORG} \
  --output reference_panel/split/1000GP.chr22.noNA12878
  
done < 1000GP_chr22_chunks_glimpse2.txt

