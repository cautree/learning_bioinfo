
## get the line with mpg
```
sed -nr '/mpg/p' mtcars.csv

```


## $ means end of the file

```
sed -e '11,$ d' mtcars.csv ## with only 10 lines left

```


## p flag
```
# the replaced line will show twice
sed 's/unix/linux/p' geekfile.txt

sed 's/unix/linux/' geekfile.txt

```

## change from line 2 to the end
```
sed '2,$ s/unix/linux/' geekfile.txt

```

## Deleting lines from a particular file
```

sed '3d' filename.txt
```

## To Delete line from range x to y
```
sed '1,2d' geekfile.txt

```

## to Delete pattern matching line
```
sed '/abc/d' filename.txt
```

## To Delete from nth to last line
```
sed '12,$d' filename.txt
```



## change d to p, but also using -n to aovid double print
```

sed -n '3p' mtcars.csv
sed -n '1,2p' mtcars.csv
sed -n '/mpg/p' mtcars.csv
sed -n '12,$p' mtcars.csv
```


