Azenta_20241023

##facts about the data

largest one end reads size 82.3G

after alignment,  BAM file is 223G
markduplicates need RAM as big as the BAM file
markduplates aws using m5a.16xlarge, and run for 5 hours
m5a.16xlarge has 256G memory


##computer enviroment change

nextflow-20231222-cpu16-mem64-disk1000 
m4.10xlarge, m5.8xlarge, m5a.12xlarge, m5a.16xlarge

nextflow-20231220-cpu4-mem16-disk200
m5.xlarge, m5.2xlarge