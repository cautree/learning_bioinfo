
#test successful
nextflow run nf-core/phaseimpute -r dev -profile test,docker --outdir nf_phase_test_out -resume


~/Documents/projects/20241008_eremid/nf-core/phaseimpute/tests/csv/panel_full.csv \


nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "GRCh38" \
--tools "glimpse2" \
--panel panel.csv \
--steps "panelprep" \
--input samplesheet/sample_bam.csv



nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "GRCh38" \
--tools "glimpse2" \
--panel panel.csv \
--steps "impute" \
--input samplesheet/sample_bam.csv \
--chunks chunks.csv



##is other species working?
nextflow run nf-core/phaseimpute -r dev -profile docker \
--outdir nf_phase_pacbio_out -resume \
--genome "TAIR10" \
--tools "glimpse2" \
--panel panel.csv \
--steps "impute" \
--input ../test_nf_impute/samplesheet/sample_bam.csv \
--chunks ../test_nf_impute/chunks.csv


## downsample to 1x, can only be integer
```
nextflow run nf-core/phaseimpute \
    --input samplesheet_sim/sample_bam.csv  \
    --steps simulate \
    --depth 1 \
    --outdir depth_2_simulated \
    --fasta reference_genome/chr22.fa \
    -profile docker -r dev \
    -resume -bg
    
```


## validation
```
nextflow run nf-core/phaseimpute \
    --input samplesheet_input.csv \
    --input_truth samplesheet_truth.csv \
    --posfile posfile.csv \
    --steps validate \
    --outdir validation_results \
    --genome GRCh38 \
    -profile docker \
    -r dev 

```