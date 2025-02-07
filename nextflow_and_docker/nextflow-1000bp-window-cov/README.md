# get the coverage and GC in 1000bp window

##1  get the reference for the run *ref_list* 


##2 download the reference
```
get_ref.sh

```

##3 get the index for all the ref
```
nextflow run index_ref.nf
cp fasta/* ref/
```

##4  rename the .md.bam file with a map
```
cat old_new
# A2001_F08       Bacillus_cereus.A2001_F08
# A2001_F09       Bacillus_cereus.A2001_F09
# A2001_F06       Bacillus_cereus.A2001_F06
# A2001_F07       Bacillus_cereus.A2001_F07
# C1003_F10       Bacillus_cereus.C1003_F10

while read old new; do mv $old.md.bam $new.md.bam; done < old_new

```

## run the bedcoverage.nf
```
nextflow run bedcoverage.nf -resume -bg

```