

if(!params.data_type) {
    error("no data type specified --data_type: wgs or wes or rna")
}
if(!params.file_csv) {
    error("no input file csv provided --file_csv")
}
if(!params.out_dir) {
    error("no output dir provided --out_dir")
}

include { foo } from './subworkflows/foo.nf'


workflow {

    foo()
}

//https://stackoverflow.com/questions/76871451/nextflow-groovy-set-input-parameters-and-check