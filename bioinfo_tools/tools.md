
## incrond trouble shooting

1. Try this first

When in doubt:

sudo /etc/init.d/incrond stop
sudo /etc/init.d/incrond start

2. Try this (not sure if this matters...)

Then, remove broken file, and give unique, then try again.


## incrond usage

```
### start, stop and inspect incron
a. sudo /etc/init.d/incrond start
b. sudo /etc/init.d/incrond status
c. sudo /etc/init.d/incrond stop

### use for create delivery
/shared/generate_delivery/ IN_CREATE /bin/sh
/software/nextflow-demux/scripts/start_delivery.sh $#




```


## the bash scripts
```
#!/bin/bash

manifest=$1
samp=$(basename "${manifest%.*}")
samp=`echo $samp | cut -d_ -f1-2`
dir=/shared/fastq/${samp}

if [ -d $dir ]; then
rm -rf $dir
fi

mkdir $dir
cd $dir 

mv /shared/generate_delivery/$manifest .

/software/nextflow-demux/nextflow run \
 /software/nextflow-demux/demux_delivery.nf \
 -bg \
 -work-dir s3://seqwell-fastq/$samp/work \
 --plates $manifest

```