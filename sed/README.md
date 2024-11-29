
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