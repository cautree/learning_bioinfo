library(dplyr)

df_lima_report = readr::read_tsv("../LongPlex-main/output/LongPlex_demux_out/bc1015/lima_out/demux_i7_i5/bc1015.lima.report")


## select ZMW column and any columns with Named
df_named = df_lima_report %>% 
  dplyr::select( c(ZMW ,contains("Named") ) )