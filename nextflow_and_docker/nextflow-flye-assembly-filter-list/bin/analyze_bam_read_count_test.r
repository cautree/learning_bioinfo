#!/usr/bin/env Rscript

# Load necessary libraries
library(dplyr)
library(tidyr)
library(readr)

# Get arguments: sample_id and bam_readcount file path
args <- commandArgs(trailingOnly = TRUE)
bam_file <- "bc20250228C05.bam.readcount.txt"  # Example file, update as needed
sample_id <- 'bc20250228'  # Example sample ID, update as needed

# Read in the bam-readcount output file
bam_data <- readr::read_table(bam_file, col_names  = FALSE)

# Rename the columns for clarity
colnames(bam_data) <- c("Index", "Position", "RefBase", "TotalReads", "OtherColumns", "BaseCall_A", "BaseCall_C", "BaseCall_G", "BaseCall_T", "BaseCall_N")

# Reshape the data using pivot_longer to get base calls in long format
df_long <- bam_data %>%
  select(Position, RefBase, TotalReads, BaseCall_A, BaseCall_C, BaseCall_G, BaseCall_T, BaseCall_N) %>%
  pivot_longer(cols = BaseCall_A:BaseCall_N, names_to = "BaseCallType", values_to = "Count") %>%
  mutate(BaseCallType = str_replace(BaseCallType, "BaseCall_", ""))  # Clean the BaseCallType names

df_modified <- df_long %>%
  mutate(Count = sub("^[^:]*:([^:]*).*", "\\1", Count)) %>% 
  dplyr::mutate( Count = as.numeric(Count))



df_transformed = df_modified %>% 
  dplyr::group_by( Position) %>% 
  dplyr::summarise( TotalReads = sum(Count))

df_transformed2 <- df_modified %>%
  tidyr::nest( data = -Position)

df_transformed2$data[[1]]

# Print the transformed data
print(df_transformed)

# Print the transformed data
print(df_modified)

# Print the transformed data
print(df_transformed)