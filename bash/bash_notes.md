# bash notes

## date

```
date 

date +%h
#Oct, month in human readable 3 letters

date +%m
#12, month in number
```


## cal
```
cal
## display calendar

```

## printf 
```

printf Hello World
#Hello

printf "Hello World\n"

printf "Current shell is %s \n" $SHELL

```

## script

```
script
exit
## appending mode
script -a
script mylogfile

```


## for loop
```
for x in 1 5 10 4
do
 echo “Value of x is $x”
done
  


```


## $@ $*
## when sure there is no blank in the argment, $* is good enough
```
sh sum.sh 10 20 30


```

## set and shift
```
set 13 45 32
echo “Argument one:$1, Argument 2:$2, Argument 3:$3”
echo “There are $# number of arguments”


set `date`
echo $1 $2 $3
shift 2   #shifting two positions at a time

```