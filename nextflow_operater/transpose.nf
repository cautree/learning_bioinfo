
data =  [
    [1, 'a', ['a1', 'a2']],
    [2, 'b', ['b1', 'b2', 'b3']],
    [3, 'c', ['c1']]
]


Channel.from(data).transpose().view()


//[1, a, a1]
//[1, a, a2]
//[2, b, b1]
//[2, b, b2]
//[2, b, b3]
//[3, c, c1]
