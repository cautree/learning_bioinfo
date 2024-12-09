params.gimme_scan_bed_files = './results/extract_gimme/*/*.bed'
params.coord_bed_files = './results/motifs_nr_coord/*.bed'

params.outdir = './outdir'



process INTERSECT {

    tag { scan_id }

    publishDir "${params.outdir}/intersect", mode: 'copy'

    input:
    tuple val(scan_id), path('bed_dir/*')
    path 'coord_dir/*'

    output:
    tuple val(scan_id), path("${scan_id}/*")

    shell:
    '''
    mkdir "!{scan_id}"
    for bed in bed_dir/*; do

        bedtools intersect \\
            -a "${bed}" \\
            -b "coord_dir/$(basename "${bed}")" \\
            -wa |
        sort \\
            -u \\
            > "!{scan_id}/$(basename "${bed}" '.bed')_intersected.bed"
    done
    '''
}




workflow {

    Channel
        .fromFilePairs( params.gimme_scan_bed_files, size: -1) {
            it.parent.name.substring(it.parent.name.lastIndexOf('_') + 1)
        }
        .set { gimme_scan_bed_files }

    Channel
        .fromPath( params.coord_bed_files )
        .collect()
        .set { coord_bed_files }

     INTERSECT( gimme_scan_bed_files, coord_bed_files )

     INTERSECT.out.view()
}


//https://stackoverflow.com/questions/75901751/how-to-call-bash-script-in-nextflow-and-manage-multiple-inputs