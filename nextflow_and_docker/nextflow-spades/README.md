

## get the files.  *get_fa.sh*
```
#!/bin/bash

aws s3 ls s3://seqwell-analysis/20250115_NextSeq2000/spades_assembly/ | cut -c32- | sed 's|/||' > sample_folder
cat sample_folder | cut -c1-9 > sample_ID

paste sample_folder sample_ID > file_info
while read folder ID; do
aws s3 cp s3://seqwell-analysis/20250115_NextSeq2000/spades_assembly/${folder}/contigs.fasta  ${ID}.contigs.fasta  
done < file_info

rm sample_folder sample_ID file_info
```
