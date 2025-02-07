params.reference = 'Bacillus_subtilis.fa'

//get bam index
process get_bam_index{

publishDir path: "ref", mode: "copy"

input:
    path(ref)

output:
    path("*.fa.*")

  """
  bwa index $ref
  """
}


//get fai index
process get_fai_index{

publishDir path: "ref", mode: "copy"

input:
    path(ref)

output:
    path("*.fai")

  """
  samtools faidx $ref
  """
}





process get_dict{

publishDir path: "ref", mode: "copy"

input:
    path(ref)

output:
    path("*.dict")

  """
  bs=\$(basename $ref .fa)
  java -jar /usr/local/bin/picard.jar CreateSequenceDictionary \\
      R=$ref \\
      O=\$bs.dict
  """
}



workflow {
  ref_channel = channel.fromPath( "fasta/*" )
  ref_channel.view()
  get_bam_index( ref_channel)
  get_fai_index( ref_channel)
  get_dict( ref_channel)
}