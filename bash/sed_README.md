## sed

#### replacement except the first line
```

sed '2,$s/PATTERN1/PATTERN2/' filename

awk '/Merc/' mtcars.txt | tee merc.txt

awk '$1~/Merc/' mtcars.txt | tee merc.txt

```


## some common sed commands
### https://seneca-ictoer.github.io/ULI101/A-Tutorials/tutorial10
```
sed -n '3,6 p' stuff.txt           ##print line 3 to 6
sed '4 q' stuff.txt                ##print first 4 lines
sed '/the/ d' stuff.txt            ##for line with the, delete
sed 's/line/NUMBER/g' stuff.txt    ##replace "line" with "NUMBER"
```