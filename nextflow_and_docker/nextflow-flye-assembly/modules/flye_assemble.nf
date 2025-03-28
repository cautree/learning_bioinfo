process FLYE_ASSEMBLE {
    tag "${pair_id}"

//    errorStrategy 'ignore'

    input:
      tuple val(pair_id), path(fq) 

    output:
      tuple val(pair_id), path("*.assembly_graph.gfa"), emit: flye_gfa 
      path('*.assembly_info.txt'), emit: flye_txt
      tuple val(pair_id), path('*.assembly.fasta'), emit: flye_fasta

    """
      mkdir data
      flye --nano-corr ${fq} -g ${params.genome_size} --meta   --out-dir data  
      mv data/assembly_info.txt ${pair_id}.assembly_info.txt 
      mv data/assembly.fasta ${pair_id}.assembly.fasta
      mv data/assembly_graph.gfa  ${pair_id}.assembly_graph.gfa 
    """
}
