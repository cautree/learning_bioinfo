
nextflow.enable.dsl = 2

params.run = "20250115_NextSeq2000"
params.plate = "A2001_clean_FASTQ"
params.downsample_map = "map.csv"

process generate_samplesheet {
    publishDir "bin", mode: 'copy'
    
    input:
    val(run) 
    val(plate) 
    path(downsample_map) 
    
    output:
    path "samplesheet.csv"

    script:
    """
    aws s3 ls s3://seqwell-fastq/$run/$plate/ | cut -c32- > file

    cat file | grep R1 > left
    cat file | grep R2 > right

    while read line; do 
        echo s3://seqwell-fastq/$run/$plate/\$line >> fq_1_file
    done < left 

    while read line; do 
        echo s3://seqwell-fastq/$run/$plate/\$line >> fq_2_file
    done < right

    cat file | cut -d. -f1 | sed 's|_R1_001||' | sed 's|_R2_001||' | sort | uniq > name 

    echo 'pair_id,fq_1,fq_2' > temp1
    paste name left right | tr '\t' ',' > temp2
    cat temp1 temp2 > file1.csv

    echo "pair_id,fq_1,fq_2,downsample" > file3.csv
    while IFS=',' read -r pair_id downsample group; do
        if [[ "\$pair_id" == "pair_id" ]]; then continue; fi
        grep "^\$pair_id," file1.csv | while IFS=',' read -r id fq1 fq2; do
            echo "\$id,\$fq1,\$fq2,\$downsample,\$group" >> file3.csv
        done
    done < $downsample_map

    awk -F',' 'NR==1 {print \$0",out_fq_1,out_fq_2"; next} 
             {out_fq_1=\$1"_"\$5"_R1_001.fastq.gz"; out_fq_2=\$1"_"\$5"_R2_001.fastq.gz"; 
             print \$0","out_fq_1","out_fq_2}' file3.csv > samplesheet.csv
    """
}


workflow {
  
  map_ch = Channel.fromPath( params.downsample_map)
  
  generate_samplesheet( params.run, params.plate, map_ch )
}