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

## -i option in ls: inode
Every file is associated with a table that contains various attributes of a it, except its name and contents. This table is called as inode (index node) and accessed by the inode number.
```
ls –il test # the first number is the inode

```


## hardlinks
Multiple names (links) provided to one single file are all having same inode number. The link count is displayed when ls –l is used
A link can be created to a file using ln command. 
```
ln test test_link
ls -li test test_link

## number 2 is the link count
#27469449 -rw-r--r--@ 2 sm985  staff  0 Dec 15 22:20 test
#27469449 -rw-r--r--@ 2 sm985  staff  0 Dec 15 22:20 test_link


## now the link count is three
ln test test_link2
ls -li test test_link test_link2
```


## ls -R recursive listing
```
ls -R 

```

## symbolic links
```
ln -s test test.sym
ls -li test test.sym

```

## unmask: default file and directory permission

When you create files and directories, the permissions assigned to them depend on the
default setting of the system. The UNIX system has the following default permissions for all
files and directories –
```
rw-rw-rw- (octal 666) for ordinary files
rwxrwxrwx (octal 777) for directories

```

## find to locate files
find path_list selection_criteria action

```
find   /Users/yanyan/Documents/GitHub/software/learning_bioinfo/bash -name "*.sh" -print
## path_list: /Users/yanyan/Documents/GitHub/software/learning_bioinfo/bash
## selection_criteria: -name "*.sh"
## action: -print

```


## pr: paginating files
```
pr emp.list
pr -t -3 emp.list
pr -t -d -3 emp.list
pr -t -n emp.lst

```


## cut

```
cut -c 6-22,24-32 emp.list
cut -d \| -f 2,3 emp.list
cut -d "|" -f 1,4- emp.lst


```