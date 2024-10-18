#/bin/bash

ls ../ref | grep -E '.fa$' > file

while read line; do
echo $line
id=$(basename $line .fa)
echo $id >> ${id}.length
cat ../ref/${line} | paste - - | awk '{print length($2)}' >> ${id}.length
done < file 
rm file

cat *length | paste - - | tr '\t' ',' > reference_length_count.csv
rm *.length
