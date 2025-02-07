
while read line; do 

aws s3 cp s3://seqwell-ref/${line}.fa .

done < ref_list
