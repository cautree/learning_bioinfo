
peek vcf 
https://genome.sph.umich.edu/wiki/Vt#Peek
######################################
# for site with snps
######################################
mkdir -p c1
ls ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out_with_SNP | grep SEQW | grep c1 | grep -v gz > file

while read line; do
sample_id=$(basename $line .c1.vcf)
echo $sample_id >> c1/${sample_id}.c1.imputation_score.txt
cat ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out_with_SNP/$line | grep -v "#" |  awk '{print $8}' | cut -d";" -f3 | cut -d"=" -f2 >> c1/${sample_id}.c1.imputation_score.txt
done < file
rm file



mkdir -p non_c1_filtered
ls ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out | grep SEQW
ls ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out | grep SEQW | grep -v bcf | grep -v gz > file

while read line; do
sample_id=$(basename $line .c1.vcf)
echo $sample_id >> non_c1_filtered/${sample_id}.c1.imputation_score.txt
cat ~/Documents/projects/20241008_eremid/imputation/glimpse_1_nextflow_working/glimpse_sample_out/$line | grep -v "#" |  awk '{print $8}' | cut -d";" -f3 | cut -d"=" -f2 >> non_c1_filtered/${sample_id}.c1.imputation_score.txt
done < file
rm file
