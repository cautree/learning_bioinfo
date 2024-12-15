#!/bin/sh
#sum of numbers given through command line
sum=0
for x in $* 
do
     sum=`expr $sum + $x`
done

echo "Sum = $sum"