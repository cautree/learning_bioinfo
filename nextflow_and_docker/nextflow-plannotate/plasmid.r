library(plasmapR)
library(dplyr)


gb_file <- "plannotate_out/MY5FNR_1_BaCD00067367_pLann.gbk"
plasmid_data <- read_gb(gb_file)


plot_plasmid(plasmid_data,name = "pETM-20")
