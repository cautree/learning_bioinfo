# AWK

## simple awk filtering
```
awk '/director/{print}' emp.lst

```


## Splitting a line into fields
```
awk -F "|" '/sales/{print $2,$3,$4,$6}' emp.lst
awk -F"|" '/sa[kx]s*ena/' emp.lst
awk -F "|" 'NR==3, NR==6 {print NR, $2, $3,$6}' emp.lst
```

## printf: Formatting Output
```
awk -F "|" '/director/ { printf "%3d %-20s %-12s %d\n", NR, $2, $3, $6}' emp.lst

## sort inside awk
awk -F "|" '/director/ { printf "%-20s %-12s\n", $2, $3 | "sort"}' emp.lst
```



