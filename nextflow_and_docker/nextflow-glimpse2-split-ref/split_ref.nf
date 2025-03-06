
params.chr = "chr1"

process split_ref {
  
  container "glimpse:v2.0.0-27-g0919952_20221207"
  
  publishDir path: "s3://seqwell-ref/glimpse2/split_genome_${params.chr}/",  mode: 'copy'
  
  input:
  path(REF)
  path(MAP)
  path(chunk)
  
  output:
  path("*")
  
  """
  

while IFS="" read -r LINE || [ -n "\$LINE" ];
do
  printf -v ID "%02d" \$(echo \$LINE | cut -d" " -f1)
  IRG=\$(echo \$LINE | cut -d" " -f3)
  ORG=\$(echo \$LINE | cut -d" " -f4)

  GLIMPSE2_split_reference --reference ${REF} --map ${MAP} --input-region \${IRG} --output-region \${ORG} --output 1000GP.${params.chr}.noNA12878
done < $chunk
  
  """
  
  
}


workflow {
  
  ref_ch = channel.fromPath("s3://seqwell-ref/vcf/1000GP." + params.chr + ".noNA12878.sites.vcf.gz*").collect()
  map_ch = channel.fromPath("s3://seqwell-ref/glimpse2/gmap/" + params.chr + ".b38.gmap.gz")
  chunk_ch = channel.fromPath("s3://seqwell-ref/glimpse2/split_genome_" + params.chr + "/chunks." + params.chr +".txt")
  
  split_ref( ref_ch, map_ch, chunk_ch)
  
  
}
