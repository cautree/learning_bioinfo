workflow {
    numbers = Channel.of(1, 2)

    numbers
    | flatMap { n -> [ n, [n*10, n*100] ] }
    | view
}