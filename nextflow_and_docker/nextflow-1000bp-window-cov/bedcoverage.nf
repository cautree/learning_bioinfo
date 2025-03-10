
params.dev = true
params.ref = "*.fa"





//Bacillus_cereus.A2001_F07.md.bam 
//cat *.csv | awk -F,  '{print $2"."$1}'
bam_ch = Channel
       .fromPath("bam/*.md.bam")
        .map{ it -> tuple(  it.baseName.tokenize(".")[0..1].join("_"),  it.baseName.tokenize(".")[0], it)}
      //  .take( params.dev ? params.number_of_inputs : -1 )





process index_fa {

publishDir path: "ref", mode: "copy"

input:
tuple val(ref_name), path(ref_fa)
          
output:
tuple val(ref_name), path("*.fai")
          
"""
samtools faidx ${ref_fa}
"""
}



process get_ref_bed {

publishDir path: "ref", mode: "copy"

input:
tuple val(ref_name), path(ref_fai)
          
output:
tuple val(ref_name), path("*.bed")
          
"""
awk 'BEGIN {FS="\t"}; {print \$1 FS "0" FS \$2}' ${ref_fai} > ${ref_name}.bed
"""
}



process get_ref_bed_1000bp_window {

publishDir path: "ref", mode: "copy"

input:
tuple val(ref_name), path(ref_bed)
          
output:
tuple val(ref_name), path("*.1000.bed")

"""
bedtools makewindows -b ${ref_bed} -w 1000 > ${ref_name}.1000.bed

"""

}



process get_ref_bed_1000bp_window_GC {

publishDir path: "GC", mode: "copy"

input:
tuple val(ref_name), path(ref_1000_bed), path(ref_fa)


output:
tuple val(ref_name), path("*.1000.GC.tsv")

"""
bedtools nuc -fi ${ref_fa} -bed ${ref_1000_bed} > ${ref_name}.1000.GC.tsv
     
"""
}



process index_mdbam {

input:
tuple val(ref_name), val(sample_id), path(sample_mdbam)


output:
path("*.md.bam.bai")

"""
samtools index ${sample_mdbam}

"""


}



process get_bed_cov {

publishDir path: "cov", mode: "copy"

input:
tuple val(ref_name), val(sample_id), path(sample_mdbam), path(sample_mdbam_index), path(ref_fa), path(ref_1000_bed)


output:
tuple val(ref_name), val(sample_id), path("*.bedcov.txt")

"""
samtools bedcov \
 --reference ${ref_fa} \
 ${ref_1000_bed} \
 ${sample_mdbam} > ${sample_id}.bedcov.txt 
     
"""
}



workflow {

ref_ch = Channel
         .fromPath("ref/*.fa")
         .map{ it -> tuple (it.baseName.tokenize(".")[0], it  ) }
         
         

        
bam_indx_ch = index_mdbam(bam_ch)
        .map{ it -> tuple(  it.baseName.tokenize(".")[0..1].join("_"),  it.baseName.tokenize(".")[0], it)}

bam_and_index_ch = bam_ch
                   .join( bam_indx_ch, by: [0])
                   .map{ it -> tuple( it[1], it[0], it[2], it[4])}


index = index_fa( ref_ch)
bed = get_ref_bed( index)
bed_1000 = get_ref_bed_1000bp_window (bed)

bed_1000_ref = bed_1000.join(ref_ch )
get_ref_bed_1000bp_window_GC( bed_1000_ref )

ref_ch.view()
bed_1000.view()
//bam_and_index_ch.view()

joined_ch = ref_ch
            .join(bed_1000)
            .cross(bam_and_index_ch)
            
//joined_ch.view()
            
joined_ch_clean = joined_ch
                  .map{item -> tuple(item[1][0], item[1][1], item[1][2],item[1][3], item[0][1], item[0][2])}
 joined_ch_clean.view()                 
get_bed_cov(joined_ch_clean)
}




