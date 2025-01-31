

params.fa_a = "data/ASUPlasmidReference/*.fasta"
params.outfile = "seqwell_compare"
params.fa_b = "data/seqwell/seqwell_selected/*.fasta"
params.outdir = "blastn_results"



process get_blast_res {

publishDir path: "${params.outdir}/${params.outfile}.blastn_metric", mode: 'copy'

input:
tuple  val(sample_id), path(fa_1), path(fa_2)


output:
path ("*.txt")

"""

blastn \
       -num_threads $task.cpus \
       -query ${fa_1} \
       -subject ${fa_2} \
       -outfmt 6 \
       -num_alignments 1 \
       -out ${sample_id}.txt

"""


}



process combine_blast_metrics {

publishDir path: "${params.outdir}", mode: 'copy'

input:
tuple val(plate_id), path(blast_res)

output:
file ("*" )

"""
  combine_metrics.py ${params.outfile}
"""

}




workflow {

//01_AP-11878.fasta
Channel
      .fromPath( params.fa_a , checkIfExists: true )
      .map { tuple( it.baseName.tokenize(".")[0],   it ) }
      .set {ref_file}
      
ref_file.view()

//BC27_01_AP-11878.assembly.fasta        
Channel
      .fromPath( params.fa_b ,  checkIfExists: true )
      .map { tuple( it.baseName.tokenize(".")[0],  it ) }
      .set {gfa_file}
      
gfa_file.view()   
    //val(sample_id),val(ref_name), path(fa_1), path(fa_2)
    combined_ch = ref_file
                  .join( gfa_file)

    combined_ch.view()
    
    
    res_ch = get_blast_res(combined_ch)
    
    all_res_ch = res_ch
            .collect()
            .map{ it -> tuple( params.outfile, it)}
            
    all_res_ch.view()

    combine_blast_metrics(all_res_ch)       
}



