process PLANNOTATE {
  
    //publishDir path: "${params.output}/${params.plates}/${plate_id}_GBK", pattern: '*.gbk', mode: 'copy'
 
    input:
    tuple val(pair_id), path(fa)

    output:
    path("*.gbk") 

    script:
    """
    mkdir ${pair_id}
    plannotate batch -i $fa --output ${pair_id}
    cp ${pair_id}/${pair_id}*pLann.gbk  ${pair_id}.gbk
    """
}
