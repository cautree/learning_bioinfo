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


awk -F "|" '/director/ { printf "%-20s %-12s\n", $2, $3 > "nlist"}' emp.lst
```

## VARIABLES AND EXPRESSIONS

```
## awk doesn’t contain data types like int, char, float etc. 
## Every expression can be interpreted as either a string or a number.


```

## The Regular Expression Operators: ~ and !~
```
awk -F "|" '$2 ~ /[cC]how*dh*ury/ || $2 ~ /sa[kx]s?ena/ {print}' emp.lst

awk -F "|" '$3!~ /director|chairman/{print $2, $3}' emp.lst
```


## number comparison
```
awk -F"|" '$6>7500 {printf "%-20s %d\n",$2,$6}' emp.lst
awk -F"|" '$6>8000 || $5~/45$/{print $2, $5, $6}' emp.lst

```

## Number Processing
```
awk -F "|" '$3=="director" {printf "%-20s %-12s %d %d %d\n", $2, $3,$6, $6*0.4, $6*0.15}' emp.lst

```

## Variables
```
awk -F "|" '$3=="director" && $6>=7000 {
    count++
    printf "%d %-20s %-12s %d\n", count, $2, $3, $6}' emp.lst

```

## begin and end sections
```
## this does not work
#newPayroll.awk

BEGIN {
    printf "SlNo \t Name \t\t Salary\n"
} 
$6>7500{
    count++
    total += $6
    printf "%3d %-20s %d\n", count, $2, $6
} END{
    printf "\nThe average salary is: %d\n", total/count
}


awk –F “|” –f newPayroll.awk emp.lst

```


## NF, FILENAME
```
awk 'BEGIN { FS="|"} NF !=6 { print "Record No ", NR, "has ", NF, " fields"}' emp.lst 
awk '$6<4000 {print FILENAME, $0}' emp.lst

```

## Array
```

awk -f avgSal.awk emp.lst
##printf "%50s\n" right-justifies a string within a field that is 50 characters wide

##avgSal.awk

BEGIN {

      FS= "|"
      printf "%50s\n",  "Basic  DA  HRA Gross"

} /sale|marketing/ {

    da = 0.25*$6
    hra = 0.5*$6
    gross = $6 + hra + da

    tot[1] += $6
    tot[2] += da
    tot[3] += hra
    tot[4] += gross

    c++


} 
END {

 printf "\t Average %5d %5d %5d %5d\n", tot[1]/c, tot[2]/c, tot[3]/c, tot[4]/c 

}

```



## awk functions
```
awk -F"|" 'length($2)<12' emp.lst

```


## index(s1,s2)
It determines the position of a string s2 within a larger string s1

```
# error
# awk: syntax error at source line 1
# context is
#        BEGIN{  x=index("abcde", "b") >>>  print <<<  x}
#awk 'BEGIN{  x=index("abcde", "b") print x} ' 

awk 'BEGIN{  x=index("abcde", "b"); print x} ' 

```
## substr(string, start_position, length)
```
## this works
awk 'BEGIN{ x=substr("hello how are you?", 7,3); print x} '

## this works also

awk 'BEGIN{
    x=substr("hello how are you?", 7,3)
print x}'

```


## split(string, arr, delimiter)
Splits string stg into array arr using ch as delimiter and returns number of fields
```
awk 'BEGIN{ x=substr("hello how are you?", 7,3) ; print x}'

## this works also
awk 'BEGIN{ x=substr("hello how are you?", 7,3) 
 print x}'
 
```


## control flow
```
awk -F "|" '{ if ($6>8000) printf "%s\t%d\n", $2, $6}' emp.lst

awk -F"|" '{ if($6>8000 && $3=="director") printf "%s\t %s\n", $2, $6}' emp.lst

awk -F"|" '{ if($2~/[cC]ho[wu]dh?ury|sa[xk]s?ena/) printf "%s\t%s\n", $2, $3}' emp.lst


awk 'BEGIN{ 
    a=10
    b=20
if(a>b)
    print "a is greater"
 else
 print "b is greater" }'
    



```



## looping with for
```
awk 'BEGIN{ for(i=1;i<=5;i++) printf "%d\t", i }'

awk 'BEGIN{ 
    for(i=1;i<=5;i++)
printf "%d\t", i }'


awk -F"|" '{count[$3]++}
END {for (desig in count)
print desig, count[desig]}' emp.lst

```

## looping with while
```

awk 'BEGIN{ while(k<5) 
{ printf "%d\t", k 
  k++
}
} '

```