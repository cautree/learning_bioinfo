def squareIt = { it * it }
def addTwo = { it + 2 }

workflow {
    Channel.of( 1, 2, 3, 4, 5 )
    | map( squareIt >> addTwo )
    | view
}
