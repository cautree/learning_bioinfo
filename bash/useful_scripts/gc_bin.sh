#!/bin/bash

run=20210306_MiSeq-Appa

dir=${run}_GCbins
mkdir -p $dir 

for i in metrics/*GC.txt
do samp=$(basename $i .GC.txt)
cat $i | tail -n 104 | head -n 102 | cut -f3,6,7 | sed 's/\t/,/g' > $dir/$samp.GC.csv
done

zip $dir.zip $dir/*

dir=${run}_insertbins
mkdir -p $dir

for i in metrics/*insert.txt
do samp=$(basename $i .insert.txt)
cat $i | awk 'NR > 10' | cut -d. -f1 | sed 's/\t/,/g' > $dir/$samp.insert.csv
done

zip $dir.zip $dir/*

