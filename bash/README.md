
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