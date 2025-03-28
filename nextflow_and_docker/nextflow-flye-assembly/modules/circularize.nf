process CIRCULARIZE {
   // publishDir path: "${params.output}/${params.plates}/${plate_id}_GFA", pattern: '*.final.gfa', mode: 'copy'
   // publishDir path: "${params.output}/${params.plates}/${plate_id}_FASTA", pattern: '*.final.fasta', mode: 'copy'

    input:
     tuple  val(pair_id), path(gfa)

    output:
     tuple  val(pair_id), path("*.final.gfa"), path("*.final.fasta")
     tuple  path('*.info.csv'), emit: circle_csv
     tuple  val(pair_id),  path("*.final.fasta"), emit: assembled_fa


    script:
    """
    if [ -s $gfa ]; then
        Graph.py
    else
        touch ${pair_id}.final.gfa
        touch ${pair_id}.final.fasta
        touch ${pair_id}.info.csv
    fi
    """
}

