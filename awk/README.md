
## use awk to add column
```
input=mtcars.csv
id=1
depth=1000
prefix=mtcars
HEADER_STR="mpg,cyl,disp,hp,drat,wt,qsec,vs,am,gear,carb"
HEADER_LINE=$(grep -n -m 1 "^${HEADER_STR}" $input | cut -d: -f1 )
HEADER_START=$((HEADER_LINE ))

##add two different columns at the end
tail -n +$HEADER_START $input |  tr ',' '\t' | awk -v id=$id 'NR==1{$(NF+1)="ID"} NR>1{$(NF+1)=id}1' | awk  -v depth=$depth 'NR==1{$(NF+1)="Depth"} NR>1{$(NF+1)=depth}1' > ${prefix}.txt



```