c1 = Channel.of( 1, 2, 3 , "z")
c2 = Channel.of( 'a', 'b', 'z' )
c3 = Channel.of( 'z' )

c4=c1.mix(c2, c3)
c4.view()
