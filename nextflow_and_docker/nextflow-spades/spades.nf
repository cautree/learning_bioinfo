
params.run=""
params.plates=""
params.dev=false
params.number_of_inputs=1
(fq1, fq2)=channel.fromFilePairs("s3://seqwell-fastq/" + params.run + "/{" + params.plates + "}/*_R{1,2}_001.fastq.gz", flat: true)
     .take( params.dev ? params.number_of_inputs : -1 )
     .into(2)

fq2.view()
process spades {
  
  
  publishDir path: 's3://seqwell-analysis/${params.run}/spades_assembly', mode: 'copy'
  
  container "staphb/spades:latest"
  
  input:
  tuple val(sample_ID),  path( fq1), path( fq2) from fq1
  
  output:
  tuple val(sample_ID),  path( "*")
  
  """
  
   spades.py  -1 $fq1 -2 $fq2 -o ${sample_ID}_spades_out 
  
  """
}