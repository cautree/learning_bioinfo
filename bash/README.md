
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