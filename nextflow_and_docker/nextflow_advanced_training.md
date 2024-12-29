## operator
### 1  map
   map and named closure

```
def squareIt = { Integer num -> num * num}

workflow {
    Channel.of(1,2,3,4)
    | map ( squareIt )
    | view
}

```

### 2 view 

```

def squareIt = { Integer num -> num * num}

workflow {

    Channel.of(1,2,3,4)
    | map ( squareIt)
    | view { "Found '$it' (${it.getClass()})"}
}



```

### 3 splitCsv
```
workflow {
   Channel.fromPath("data/samplesheet.csv")
   | splitCsv ( header: true)
   | map { row -> 
         metaMap = [id:row.id, type:row.type, repeat: row.repeat]
         [metaMap, [file(row.fastq1), file(row.fastq2)]]

   }
   | view


}

```




### other notes

```
## shows the contents in the scripts
debug true

## if not using debug true, then you can use .command.log to find the log

```