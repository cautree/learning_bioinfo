bbduk to mark the matched reads lower case

```
fq=first_last_100_reads_capical.fa
../../../software/bbmap/bbduk.sh -Xmx2g \
in=$fq \
ref=no_me_barcode/barcode.fa \
maskmiddle=f \
overwrite=t \
kmask=lc \
outm=ME_but_not_demux.matched_barcode.fa \
out=ME_but_not_demux.unmatched_barcode.fa  \
k=24 \
hdist=0 \
stats=ME_but_not_demux.barcode.stats.fa.txt  \
2>>log


```