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

### 4 multiMap

```
process MultiInput {
    input:
    val(smallNum)
    val(bigNum)

    script:
    "echo -n small is $smallNum and big is $bigNum"
}

workflow {
   Channel.from(1,2,3,4,5)
   | multiMap {
     small: it
     large: it *10

   } 
   | MultiInput



}

```

### 5 groupTuple

### 6 transpose, tranpose is the opposite of groupTuple
```
workflow {
 Channel.fromPath("data/samplesheet.csv")
 | splitCsv(header: true)
 | map ( row -> 
    meta = [ id:row.id, type: row.type]
    [meta, row.repeat, [row.fastq1, row.fastq2]]
 
 )
 | groupTuple
 | transpose 
 | view


}


```



### other notes

```
## shows the contents in the scripts
debug true

## if not using debug true, then you can use .command.log to find the log

```