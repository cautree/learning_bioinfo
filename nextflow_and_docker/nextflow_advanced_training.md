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



## other notes

```
## shows the contents in the scripts
debug true

## if not using debug true, then you can use .command.log to find the log

```

## metadata propagation

### 1 
```
//replicate = replicate - ~/^rep/  is removing the "rep" character so rep1 will become 1
workflow {
  Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
  | map { id, reads -> 
  (sample, replicate, type) = id.tokenize("_")
  replicate = replicate - ~/^rep/
  meta = [sample:sample, replicate:replicate, type:type]
  [meta, reads]
  
  }
  | view
}

```
### 2
```

workflow {
  Channel.fromFilePairs("data/reads/*/*_R{1,2}.fastq.gz")
  | map { id, reads -> 
  meta = [['sample', 'replicate', 'type'] , id.tokenize("_")]
         .transpose()
         .collectEntries()
  [meta, reads]
  
  }
  | view
}


```

### 3, there are four lines that are the same
```
workflow {
  Channel.fromFilePairs("data/reads/*/*_R{1,2},fastq.gz")
  | map { id, reads -> 
    reads.collect{ it.getParent()}.collect { it.getName()}
    reads.collect { it.parent}.collect { it.name }
    reads*.getParent()*.getName()
    reads*.parent*.name

  }
  | view



}


```

### 4 including the dot minus, those two are the same
```
workflow {
  Channel.fromFilePairs("data/reads/*/*_R{1,2},fastq.gz")
  | map { id, reads -> 
    reads.collect{ it.getParent()}.collect { it.getName()}.collect{ it.minus(~/treatment/ )}
    reads*.parent*.name*.minus(~/^treatment/)

  }
  | view

}
```

### 5 final meta 

```
workflow {
   Channel.fromFilePairs("data/reads/*/*_R{12}.fastq.gz")
   | map { id, reads ->
       ( treatmentFwd, treatmentRev) = reads*.parent*.name*.minus(~/^treatment/)
    (sample, replicate, type) = id.tokenize("_")
    replicate -= ~/*rep/
    meta = [
       sample:sample,
       replicate:replicate,
       type:type,
       treatmentFwd:treatmentFwd,
       treatmentRev:treatmentRev
    ]
    [meta, reads]

   
   }




}
```

## Grouping and Splitting

### 1 groupTuple 
```
workflow {
//lose one meta info repeat for groupTuple 
MapReads ( samples, reference )
| map ( meta, bam -> [meta.subMap('id','type'), bam])
| groupTuple 
| view


}
```

### 1.1 use groupTuple and transpose to add counts in individual group

```

workflow {
   Channel.fromPath("data/samplesheet.csv")
   | splitCsv( header: true)
   | map { row ->
     meta = row.subMap('id', 'repeat','type')
     [ meta , [
        file(row.fastq1, checkIfExists: true),
        file(row.fastq2, checkIfExist: true) ]
     ] 
     
   }
   | map { meta, reads -> [meta.subMap('id', 'type'), meta.repeat, reads]}
   | groupTuple
   | map { meta, repeats, reads -> [ meta + [repeatcount:repeats.size()], repeats, reads]}
   | transpose
   | map { meta, repeat, reads -> [meta + [repeat:repeat], reads]}
   | set { samples}

   } 

MapReads ( samples, reference)
| map {   meta, bam ->
   key = groupKey( meta.subMap('id', 'type'), meta.repeatcount)
   [key, bam]
}
| groupTuple
| view


```











### other notes
```
## trim strings
demo = "one two three"
assertEquals( demo - "two", "one three")

## spread dot notation
map { id, reads -> 
     reads.collect {it.getParent()}}
map { id, reads -> 
     reads*.getParent()
     }

## submap   there are two rows are the same

workflow {
   Channel.fromPath("data/samplesheet.csv")
   | splitCsv( header: true)
   | map { row ->
     meta = [ id: row.id, repeat: row.repeat, type: row.type]
     meta = row.subMap('id', 'repeat','type')

     [ meta , [
        file(row.fastq1, checkIfExists: true),
        file(row.fastq2, checkIfExist: true) ]
     ]
     | view
      



   }
}

## use .first() to turn into a value channel
reference = Channel.fromPath("data/genome.fasta").first()



## use subMap to remove some info from the meta

workflow {
//lose one meta info repeat for groupTuple 
MapReads ( samples, reference )
| map ( meta, bam -> [meta.subMap('id','type'), bam])
| view




}


```