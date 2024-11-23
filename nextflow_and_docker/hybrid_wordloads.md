## hybrid workloads

```

process {
    withLabel: bigTask {
        executor = 'awsbatch'
        queue = 'my-batch-queue'
        container = 'my/image:tag'
    }
}

aws {
    region = 'eu-west-1'
}


```

With the above configuration, processes with the bigTask label will run on AWS Batch, while the remaining processes will run in the local computer.

Then launch the pipeline with the -bucket-dir option to specify an AWS S3 path for the jobs computed with AWS Batch and, optionally, the -work-dir to specify the local storage for the jobs computed locally:

```

nextflow run main.nf \
 -bucket-dir s3://my-bucket/some/path \
 -work-dir 'work'

```
