

process CONCORDANCE {

publishDir path: "concordance_out", mode: "copy"

input:
tuple val(pair_id), file(REFGEN), file(REFGEN_fai), file(REFGEN_dict),file(eval), file(truth_vcf), file(truth_index)

output:
file("*.tsv")


"""
gatk Concordance \
   -R $REFGEN \
   -eval $eval \
   --truth $truth_vcf \
   --summary ${pair_id}_summary.tsv

"""

}



workflow {

params.samplesheet="samplesheet/ref_eval_truth_map.csv"
samples =Channel
    .fromPath(params.samplesheet)
    .splitCsv(header: true)
    .map { row -> tuple(row.sample_id, file(row.ref),file(row.ref_fai),file(row.ref_dict), file(row.eval), file(row.truth), file(row.truth_index)) }
    
samples.view()
CONCORDANCE( samples)


}

