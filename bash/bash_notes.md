# bash notes

## conditional parameter substituion:  ${<var>: <opt> <stg>}
var is a variable to be evaluated
opt canbeanyoneofthesymbols+,-,=or?
stg is a string

## the + option, did not work on mac
```
#Assign a variable x with 10 and test for parameter substitution as shown
### do not know why this does not work
x=10
echo ${x: + "x is defined"}
echo ${y: + “y is defined”}
found=`ls`
echo ${found: + “This directory is not empty”}

```

## The – Option
if the var do not contains a defined value and it is null, then it evaluates to stg.
```
echo ${x: - 10}  #10
echo $x          #10

```

## The = option
This option goes one step ahead of – option, where it assigns the value to the variable. If we use = option inside the parameter substitution, then explicit assignment is not required.

```
echo ${x:=10}
echo $x

## forever loops
x=1
while [ $x -le 10 ]; do echo $x;done

```


## the ? option, does not work in mac
It evaluates the parameter if the variable is assigned and not null. Otherwise, it echoes a string and kills the shell.
```
fname: ? “No file name entered”

```





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


## file relative permissions
```
#category viz. owner, group owner and others (or world)
chmod u+x test          #assign(+) x(execute) to u(user)
chmod ugo+x test        #assign(+) x to u(user, group, others)
chmod a+x test          #assign(+) x to a(all)
chmod +x test           #assign(+) x to all
chmod go-r test         #remove r permission from group & others
chmod a-x, go+r test    #remove the execute permission from all and then to assign read permission to group and others
chmod o+wx test         #assign(+) w(write) and x(execuate) to others

```


## absolute permissions
```
# Read permission – 4
# Write permission – 2
# Execute permission – 1

chmod 666 test  #Assigning read and write(4+2=6) permissions to all –
chmod 644 test  #remove the write permission from group and others
chmod 761 test  #assign all permissions to owner, read and write permissions to group and only execute permission to others 
```


## use chmod recursively (-R)
```
chmod –R a+x ShellPgms   ## apply execute permission from all on all the files in ShellPgms directory

chmod -R 755 .           ## apply on hidden files also
chmod -R a+x *           ## laves out hidden files

```


## change file ownership

```
chgrp yanyan test 
#chgrp: yanyan: illegal group nam

```