//https://stackoverflow.com/questions/78764923/concatenate-group-wise-in-a-non-blocking-way-in-nextflow

process step1 {
    tag "$vehicle_type"
    debug true

    input:
    val vehicle_type

    output:
    tuple val(vehicle_type), path("vehicles.list"), emit: vehicles

    """
    #!/usr/bin/python3
    import time

    n = 2 if "${vehicle_type}" == 'boats' else 4
    with open('vehicles.list', 'w') as fout:
        for i in range(n):
            time.sleep(2)
            fout.write("${vehicle_type}" + str(i + 1) + "\\n")
    """
}



process step2 {
    tag "$vehicle_type"
    debug true

    input:
    tuple val(vehicle_type), val(vehicle)

    output:
    tuple val(vehicle_type), path("not_needed.txt"), emit: hacky_output

    """
    echo "step2: ${vehicle}" && touch not_needed.txt
    """
}



process step3 {
    tag "$vehicle_type"
    debug true

    input:
    tuple val(vehicle_type), path("txt")

    """
    echo "all ${vehicle_type} are done"
    """
}


workflow {

    vehicle_types = Channel.of('boats', 'cars')

    step1( vehicle_types )

    step1.out.vehicles
        .map { vehicle_type, vehicle_list ->
            def vehicles = vehicle_list.readLines()
            def group_key =  groupKey( vehicle_type, vehicles.size() )
            println group_key
            tuple( group_key, vehicles )
        }
      //  .transpose()
      //  .set { vehicles }

    //step2( vehicles )
    
    //step3( step2.out.hacky_output.groupTuple() )

    step1.out.vehicles.view()
    
}

