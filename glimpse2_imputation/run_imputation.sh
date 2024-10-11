#!/bin/bash

ls bam | grep -v bai > file

while read line; do

bash c_phase_ligate.sh bam/$line

done < file 
rm file