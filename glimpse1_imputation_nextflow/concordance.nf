

process CONCORDANCE {

publishDir path: "concordance_out", mode: "copy"

input:
tuple val(pair_id), file(REFGEN), file(REFGEN_fai),file(REFEN_gzi), file(REFGEN_dict), file(truth_vcf), file(truth_index), file(eval), file(eval_tbi)

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

params.samplesheet="samplesheet/pacbio_samplesheet_no_downsample_new_ref.csv"

samples =Channel
    .fromPath(params.samplesheet)
    .splitCsv(header: true)
    .map { row -> tuple(row.sample_id, file(row.ref),file(row.ref_fai),file(row.ref_gzi),file(row.ref_dict),  file(row.truth), file(row.truth_index),file(row.eval), file(row.eval_tbi)) }
    
samples.view()
CONCORDANCE( samples)


}

