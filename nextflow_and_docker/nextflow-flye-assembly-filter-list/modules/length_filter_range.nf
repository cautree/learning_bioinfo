process LENGTH_FILTER_RANGE {

  input:
    tuple val(pair_id), path(fq), val(min), val(max)

  output:
    tuple val("${pair_id}_${min}_${max}"), path("*.${min}.${max}.filtered.fastq.gz")

  script:
  """
  /usr/local/bbmap/reformat.sh \\
    in=$fq \\
    out=${pair_id}.${min}.${max}.filtered.fastq.gz \\
    minlength=$min \\
    maxlength=$max
  """
}
