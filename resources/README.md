
truth vcf

wget  https://42basepairs.com/download/web/giab/release/NA12878_HG001/NISTv4.2.1/GRCh38/HG001_GRCh38_1_22_v4.2.1_benchmark.vcf.gz
curl -O ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release/ChineseTrio/HG005_NA24631_son/NISTv4.2.1/GRCh38/HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz



bcftools view -r chr1 HG005_GRCh38_1_22_v4.2.1_benchmark.vcf.gz -Oz -o HG005_GRCh38_1_22_v4.2.1_benchmark.chr1.vcf.gz


bcftools index HG005_GRCh38_1_22_v4.2.1_benchmark.chr1.vcf.gz
bcftools index -t HG005_GRCh38_1_22_v4.2.1_benchmark.chr1.vcf.gz