//If the number of items to be grouped is known, the groupTuple size parameter can be used. 
//Once the specified size is reached, the tuple is emitted. 
//By default, incomplete tuples (i.e., with fewer than the specified size of grouped items) are discarded.


ch = channel.of( ['wt','wt_1.fq'], ['wt','wt_2.fq'], ['mut','mut_1.fq'])
            .groupTuple(size:2)
            .view()

//output
//[wt, [wt_1.fq, wt_2.fq]]