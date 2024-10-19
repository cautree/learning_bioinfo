
##merge bam

```

samtools merge eremid20240906.chr22.bam *.bam

ls ../../eremid_pacbio_20241008/vcf_on_merged_bam/bam/mdbam | grep SE | sed 's|.md.bam||' | parallel ' samtools index ../../eremid_pacbio_20241008/vcf_on_merged_bam/bam/mdbam/{}.md.bam '
ls ../../eremid_pacbio_20241008/vcf_on_merged_bam/bam/mdbam | grep SE | sed 's|.md.bam||' | parallel ' samtools view -b ../../eremid_pacbio_20241008/vcf_on_merged_bam/bam/mdbam/{}.md.bam chr22 >{}.chr22.bam '

```

## use freebayes to create vcf files, run freebayes.nf


### error permission denied if use biocontainers/freebayes:v1.2.0-2-deb_cv1
```
(base) [ec2-user@ip-172-31-3-91 vcf_on_merged_bam]$ Error executing process > 'run_freebayes (1)'

Caused by:
  Process `run_freebayes (1)` terminated with an error exit status (1)

Command executed:

  freebayes -f hg38.fa eremid20240906.chr22.bam -dd > eremid20240906.vcf

Command exit status:
  1

Command output:
  (empty)

Command error:
  .command.sh: line 2: eremid20240906.vcf: Permission denied

```

## solution use quay.io/biocontainers/freebayes:1.3.6--h346b5cb_1