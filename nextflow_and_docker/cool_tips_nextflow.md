## use nextflow to see the file in s3

```
println file('s3://my-bucket/data/sequences.fa').text

```


##  about path.baseName

When calling an object method, any method that looks like get*() can also be accessed as a field. For example, path.getName() is equivalent to path.name, path.getBaseName() is equivalent to path.baseName, and so on

## -ansi-log false

The second process runs twice, executing in two different work directories for each input file. The ANSI log output from Nextflow dynamically refreshes as the workflow runs; in the previous example the work directory [37/b9332f] is the second of the two directories that were processed (overwriting the log with the first). To print all the relevant paths to the screen, disable the ANSI log output using the -ansi-log flag (e.g., nextflow run hello.nf -ansi-log false).
