########
# make i7 i5 file, one barcode each line, cross
#########

## repeat everyline 96 times for every i7 barcode
awk '{for(i=0;i<96;i++)print}' i7_barcode.txt >  i7_barcode_96.txt 
cat i7_barcode.txt     | wc -l
cat i7_barcode_96.txt  | wc -l

## repeat i5 24 times 

for i in {1..24}; do
  cat i5_barcode.txt >> i5_barcode_24.txt
done
cat i5_barcode.txt     | wc -l
cat i5_barcode_24.txt  | wc -l
