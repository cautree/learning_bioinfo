
params.run=""
params.plates=""
params.dev=false
params.number_of_inputs=1
(fq1, fq2)=channel.fromFilePairs("s3://seqwell-fastq/" + params.run + "/{" + params.plates + "}/*_R{1,2}_001.fastq.gz", flat: true)
     .take( params.dev ? params.number_of_inputs : -1 )
     .into(2)

fq2.view()
process spades {
  
  
  publishDir path: 's3://seqwell-analysis/${params.run}/spades_assembly', pattern: '*_spades_out', mode: 'copy'
  
  container "staphb/spades:latest"
  
  input:
  tuple val(sample_ID),  path( fq1), path( fq2) from fq1
  
  output:
  path( "*")
  tuple val(sample_ID), path("*.contigs.fasta") into fa_ch
  
  """
   spades.py  -1 $fq1 -2 $fq2 -o ${sample_ID}_spades_out 
   cp ${sample_ID}_spades_out/contigs.fasta ${sample_ID}.contigs.fasta
  
  """
}

process quast { 
  
  publishDir path: 's3://seqwell-analysis/${params.run}/QUAST', pattern: '*_quast_out', mode: 'copy'
  
  input:
  tuple val(sample_ID), path (fa) from fa_ch
  
  output:
  path("*") into report
  
 """
 quast.py -o ${sample_ID}_quast_output $fa
 """

}

all_quast = report.collect()

process summarize_quast {
  
  publishDir path: 's3://seqwell-analysis/${params.run}/QUAST', pattern: '*.txt', mode: 'copy'
  
  input:
  tuple val(sample_ID), path (fa) from all_quast
  
  
  output:
  path("*quast_N50.txt")
  
 """
   ls  > quast_report
 
   while read report; do
   cat $report | sed -n -e '1p' -e '14p' -e '18p'  | awk -F"\t" '{print \$2}' | paste - - -  >> temp 
   
   done < quast_report
   
   echo "sample_contig\tcontig_count\tN50"  header 
   cat header temp > ${params.run}.spades_assembly_quast_N50.txt
 """
  
  
  
  
}