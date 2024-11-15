
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

