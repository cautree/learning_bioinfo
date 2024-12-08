## configure aws batch

https://stackoverflow.com/questions/74596201/nextflow-sarek-pipeline-on-aws-batch




## note error "No space left on device"

```
Before you create your AMI, make sure to grow your instance's EBS volume to a size large enough to handle your largest job. For Sarek, 300-500 GB is probably enough, but you might need 1 TB or more depending on sequencing depth etc

```
