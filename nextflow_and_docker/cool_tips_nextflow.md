## use nextflow to see the file in s3

```
println file('s3://my-bucket/data/sequences.fa').text

```


##  about path.baseName

When calling an object method, any method that looks like get*() can also be accessed as a field. For example, path.getName() is equivalent to path.name, path.getBaseName() is equivalent to path.baseName, and so on
