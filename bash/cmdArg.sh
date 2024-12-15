#!/bin/sh
#illustration of $@
echo "The command line arguments are:"
for x in "$@"
do
echo $x
done
