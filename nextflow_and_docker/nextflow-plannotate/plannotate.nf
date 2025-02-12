




process plannotate {
  
  publishDir path: "plannotate_out", mode: "copy"
  
  container "quay.io/biocontainers/plannotate:1.2.2--pyhdfd78af_0"
  
  input:
  tuple val( sample_ID), path(fa)
  
  output:
  tuple val(sample_ID), path("*")
  
  
  """
  mkdir ${sample_ID}
  plannotate batch -i $fa  --output ${sample_ID}
  
  """
  
}

workflow {
  
  fa_ch = Channel.fromPath( "~/Documents/projects/application_projects/Plasmidsaurus_20250129/data_analysis/data/MY5FNR_results/MY5FNR_fasta-files/MY5FNR_1_BaCD00067367.fasta")
          .map{ it -> tuple( it.baseName.tokenize(".")[0], it)}
  
  
  plannotate( fa_ch)
  
}