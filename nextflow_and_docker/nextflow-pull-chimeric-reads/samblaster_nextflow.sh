#!/bin/bash

run=20241204_Admera_health
analysis=inhouse_wgs


nextflow run samblaster.nf \
-c samblaster_nextflow.config \
--run $run \
--analysis $analysis \
-resume -bg 
