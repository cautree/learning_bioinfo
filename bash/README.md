
rename files
```
paste old new |  awk '{print "cp" " " $1 " " $2}'|sh
```

unzip gz files

```
gzip -d file.gz
```

## about date

```
today=$(date +%Y%m%d)

##get one data ago
yesterday=$(date -r $(( $(date '+%s') -   86400 )) '+%Y%m%d')
```

## using a var in awk
```
days_90=$(date -r $(( $(date '+%s') -   90*86400 )) '+%Y-%m-%d')

cat run_info | awk -v var=$days_90 '{ if( $1< var) print $2}' > run_service_to_rm 

```


## count the total reads count of all the fastq files in one folder
```
ls | grep gz | parallel 'zcat <{} | wc -l ' > line_count
cat line_count | tr -d ' ' | awk '{print $1/4}' > read_count
awk '{s+=$1} END {print s}' read_count
```


## standard out and standard error together
```
both >& outfile
```

### skipping a header in a file
```
tail +2 file
```


### throw output away
```
noisy >/dev/null  2>&1

```

## rm can not take standard input, only take its filename as argument
```
rm ${ find . -name '*.class'}

```

## $1=$1 trick, make FS same as OFS
```
awk 'BEGIN { OFS = "\t" } { $1 = $1; print }' a.txt

```

## use gsub in awk to squash the tabs
```
awk 'BEGIN { FS = "  "; OFS = "\t" } { $1=$1; gsub(/\t/, "\t"); print }' data_file

```

## remove all punctuation
```
awk  'gsub(/[^a-zA-Z0-9_ \t]/, " ", $0)'  punc.txt
```


## remove whitespace and also speciciy input seperator as space
```
awk '{ $1=$1; print }'   white_space

```

## test $1=$1 on csv files, the trick will not work, but there are some effects
```
#awk -v OFS="," '{$1=S1}' mtcars.csv
awk -F,  '{$1=S1; print $0}' mtcars.csv  #outfile is seperated by empty space
# awk -F,  '{ print $0}  END {print $NF}' mtcars.csv  # there are only 2 fields?
# awk -F, -v OFS="\t" '{ print $0} END {print $NF}' mtcars.csv # there are only 2 fields?

awk -F, -v OFS="\t" '{$1=S1; print $0}' mtcars.csv
```


## tail to exclude the first row
```
cat mtcars.csv | wc -l         #33
tail -n +2 mtcars.csv | wc -l  #32
tail -n 2 mtcars.csv | wc -l   #2
tail -n -2 mtcars.csv | wc -l   #2
tail -2 mtcars.csv | wc -l   #2
```


## grep 
```
#eXact match
grep -x "boo" a_file


```


##
-A allows you to specify additional lines of context file, 
so you get the search string plus a number of additional lines, 
```
grep -A2 "mach" a_file
```


## use regular expression in grep, these three are the same
```
grep -E "boots?" a_file
grep -E "boot|boots" a_file
grep -E "(boot|boots)" a_file

```