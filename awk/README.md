
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


## use split in awk
```
echo "12|23|11" | awk '{split($0,a,"|"); print a[3],a[2],a[1]}'

```


## awk print with decimal places
```
awk '{sum+=$1}  END {print sum} '  mtcars.txt
awk '{s+=$1} END {printf "%.3f\n", s}' mtcars.txt
```


## get a sum for a column, notice there is no punctuation in btw {}
```
cat file.txt | awk 'BEGIN {sum=0} {sum=sum+$5} END {print sum}'
cat file.txt | awk 'BEGIN {sum=0} {sum+=$5} END {print sum}'
```

$$ getline
```
seq 10 | awk '/5/{getline; print $1}'

## print line 3, 6, and 7
cat file.txt | awk '{for (i=1;i<3;i++) {getline}; print NR,$0}'

#3 -rw------- 1 mijp1 mijp1 470428 Oct 21 11:56 uniform_rand_231.agr
#6 -rw------- 1 mijp1 mijp1 255510 Oct 21 12:07 uniform_rand_period_2.agr
#7 -rw------- 1 mijp1 mijp1 376196 Oct 21 12:07 uniform_rand_period_3.agr

```

## print 5 to 10
```
awk 'NR == 5, NR == 10 { print }' text1

awk  '{ if( NR >4 &&  NR < 11)  print }' text1

awk  ' NR >4 &&  NR < 11  { print }'  text1

```


## awk filtering
```
awk '$1 != "And"' text1 | wc -l

awk '{print}' text1 | wc -l


awk '/and/ && /or/' text1

awk '/[A-E]/' text1
```


## awk filtering
```
# cololumn 4 starts with 9
awk '$4~/^9/ {print $1, $4}' table1
# column 4 not starts with 9
awk '$4!~/^9/ {print $1, $4}' table1

```

## awk filtering using ranges of patterns, the first column 1925 to 1929
```
awk '/1925/,/1929/ { print }' table1
awk 'NR == 5, NR == 10 { print }' table1
```

## awk print right adjust and left adjust
```
#awk right-justifies its output by default. To left-justify the second column, use the following program:
awk '/1920/,/1925/ { printf("%d %3d\n", $1, $5) }' table1

```

## print float point numbers
```
awk '/1920/,/1925/ { printf("%d %1.2f\n", $1, $5/154.0) }' table1
```