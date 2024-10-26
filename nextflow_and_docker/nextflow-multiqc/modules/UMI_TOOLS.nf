include { dotenv } from 'plugin/nf-dotenv'

process UMI_TOOLS_GROUP {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 1
    memory 10.GB

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("*.umi-grouped.bam"), emit: bam
    path("*.read-to-group-map.txt"), emit: metrics

    script:
    def java_memory = (task.memory.mega - 1024).intValue()
    """
    umi_tools group \\
        -I "${bam}" \\
        -S "${bam.getBaseName()}.umi-grouped.bam" \\
        --paired \\
        --method=adjacency \\
        --extract-umi-method=tag \\
        --umi-tag=RX \\
        --umi-group-tag=MI \\
        --output-bam \\
        --unmapped-reads=use \\
        --group-out="${bam.getBaseName()}.read-to-group-map.txt" \\
        --log=/dev/stderr
    """

    stub:
    """
    touch TEST-SAMPLE.umi-grouped.bam
    touch TEST-SAMPLE.read-to-group-map.txt"
    """
}
