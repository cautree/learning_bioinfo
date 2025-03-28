process PLASMIDMAP {
    //publishDir path: "${params.output}/${params.plates}/${plate_id}_plasmidMap", pattern: '*.png', mode: 'copy'

    input:
    path(gbk_file) 

    output:
    path("*.png")

    script:
    """
    plasmidMap.r
    """
}
