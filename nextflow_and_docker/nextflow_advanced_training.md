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
