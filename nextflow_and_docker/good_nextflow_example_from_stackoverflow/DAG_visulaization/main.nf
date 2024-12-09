

params.input_text = "abc"


process process_A {

    input:
    val text

    output:
    val a, emit: foo
    val b, emit: bar
    val c, emit: baz

    exec:
    (a, b, c) = text.collect()
}



process process_B {

    input:
    val x
    val y

    output:
    val z

    exec:
    z = x + y
}


process process_C {

    input:
    val a

    output:
    val b

    exec:
    b = a.replaceAll('c', '3')
}



process process_D {

    input:
    val one
    val two

    output:
    val three

    exec:
    three = two + one
}


workflow {

    entry_input = Channel.of( params.input_text )

    (output_1, output_2, output_3) = process_A(entry_input)

    (output_4) = process_B( output_1, output_2 )
    (output_5) = process_C( output_3 )

    (final_output) = process_D( output_4, output_5 )

    final_output.view()
}

