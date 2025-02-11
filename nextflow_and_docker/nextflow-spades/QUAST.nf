

//scp -i ~/.ssh/20220621_yanyan.pem  -r yanyan@54.160.117.224:/home/yanyan/spades_assembly/spades_out/C1003_A10_spades_out/contigs.fasta .

//s3://seqwell-analysis/20250115_NextSeq2000/spades_assembly/A2001_A06_spades_out/contigs.fasta




process quast { 
  
  publishDir path: "quast_out", mode:"copy"
  
  container "staphb/quast:5.3.0"
  
  input:
  tuple val(sample_ID), path (fa)
  
  
  output:
  path("*")
  
 """
 quast.py -o ${sample_ID}_quast_output $fa
 """

}

workflow {
  
  fa_ch = channel.fromPath("spades_out/*.fasta")
                  .map {it -> tuple ( it.baseName.tokenize('.')[0], it) }
          
  
  quast(fa_ch)
  
  
  
}