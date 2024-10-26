include { dotenv } from 'plugin/nf-dotenv'

process BWA_MEM {
    tag "${meta.sample_id}"
    publishDir "${params.output}/${meta.sample_id}/", mode: 'copy'

    conda 'environment.yaml'
    container "transposase_qc:${dotenv('TRANSPOSASE_QC_VERSION')}"

    cpus 26
    memory { 62.GB * task.attempt }
    errorStrategy { task.exitStatus in ((130..145) + 104) ? 'retry' : 'terminate' }
    maxRetries 2

    input:
    tuple val(meta), path(fastqs)
    path(bwa_index)

    output:
    tuple val(meta), path("*.bam"), emit: bam

    script:
    def read_structures = fastqs.size() == 3 ? "+T +T +M" : "+T +T"
    def java_memory = (task.memory.mega - 1024 * 36).intValue()
    def unmapped_bam = meta.sample_id + ".unmapped.bam"
    """
    FASTA=`find -L ./ -name "*.amb" | sed 's/\\.amb\$//'`

    # convert fastqs to BAM, using the correct read structure to incorporate UMIs if available
    fgbio -Xmx${java_memory}M FastqToBam \\
        --input ${fastqs} \\
        --read-structures ${read_structures} \\
        --sample "${meta.sample_id}" \\
        --library "${meta.sample_id}" \\
        --output "${unmapped_bam}"

    # align and merge annotations from the unmapped BAM
    samtools fastq -@ ${task.cpus} -n "${unmapped_bam}" \
    | bwa-mem2 mem \\
        -p \\
        -t ${task.cpus} \\
        -K ${params.bwa.mem.input_reads_per_batch} \\
        -Y \\
        \$FASTA \\
        - \\
    | fgbio -Xmx${java_memory}M --async-io ZipperBams \\
        --unmapped "${unmapped_bam}" \\
        --ref "\$FASTA" \\
    | samtools fixmate \\
        -@ ${task.cpus} \\
        -O BAM \\
        -m \\
        - \\
        "${meta.sample_id}.bam"

    rm "${unmapped_bam}"
    """

    stub:
    """
    touch TEST-SAMPLE.bam
    """
}
