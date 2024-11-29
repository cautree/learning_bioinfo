
## get the line with mpg
```
sed -nr '/mpg/p' mtcars.csv

```


## $ means end of the file

```
sed -e '11,$ d' mtcars.csv ## with only 10 lines left

```