process LIST_TO_FILE {
    tag "$meta.id"
    label 'process_single'

    publishDir "output", mode: 'copy'

    
    input:
    tuple val(meta), path(input, arity: '0..*'), val(id)

    output:
    tuple val(meta), path('*.id.txt'), path('*.noid.txt'), emit: txt
 


    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    # Take all files of the input and list them in a file
    # and add as second column the id
    awk 'BEGIN {
        split("${input}", f, " ");
        ids = "${id}";
        gsub(/[\\[\\]]/, "", ids);
        split(ids, i, ", ");
        for (j in f) print f[j], i[j]
    }' > ${prefix}.id.txt

    # Take all files of the input and list them in a file
    # without the id

    awk 'BEGIN {
        split("${input}", f, " ");
        for (j in f) print f[j]
    }' > ${prefix}.noid.txt

    
    """
}

workflow {

    

input_ch = Channel.of([
                    [id: "all"],
                    [file("file1.txt"), file("file2.txt")],
                    ["A", "B"]
                ])

LIST_TO_FILE(input_ch)
}