
## errorStrategy

terminate is default,
can have finish, ignore, retry

## publishDir

storageClass can be used for s3

## resourceLimits
```
process {
    resourceLimits = [ cpus: 24, memory: 768.GB, time: 72.h ]
}
```


## channel.fromPath 
channel.fromPath does not check whether the file exists
