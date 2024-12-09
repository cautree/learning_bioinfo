params.function_rds = './function.rds'
params.input_rds = './input.rds'


process my_script {

    input:
    path my_function_rds
    path my_input_rds

    output:
    path "output.rds"

    """
    script.R "${my_function_rds}" "${my_input_rds}" output.rds
    """
}

workflow {

    function_rds = file( params.function_rds )
    input_rds = file( params.input_rds )

    my_script( function_rds, input_rds )
    my_script.ou