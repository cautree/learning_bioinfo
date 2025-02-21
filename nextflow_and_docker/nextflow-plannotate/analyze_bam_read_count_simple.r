#!/usr/bin/env Rscript

# Load necessary libraries
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(stringr)

# Get arguments: sample_id and bam_readcount file path
args <- commandArgs(trailingOnly = TRUE)
sample_id <- args[1]
bam_file <- args[2]

# Read in the bam-readcount output file
bam_data <- readr::read_table(bam_file, col_names  = FALSE)

# Rename the columns for clarity
colnames(bam_data) <- c("Index", "Position", "RefBase", "TotalReads", "OtherColumns", "BaseCall_A", "BaseCall_C", "BaseCall_G", "BaseCall_T", "BaseCall_N")

# Reshape and process the base calls using pivot_longer instead of gather
result <- bam_data %>%
  select(Position, RefBase, TotalReads, BaseCall_A, BaseCall_C, BaseCall_G, BaseCall_T, BaseCall_N) %>%
  pivot_longer(cols = BaseCall_A:BaseCall_N, names_to = "BaseCallType", values_to = "BaseCallData") %>%
  mutate(counts = str_extract_all(BaseCallData, "[A-Z]:[0-9]+")) %>%
  mutate(counts = str_replace_all(counts, "(A|T|C|G|N):", "")) %>%
  mutate(counts = as.numeric(counts)) %>%
  group_by(Position) %>%
  mutate(correct_counts = sum(counts[grepl(RefBase, BaseCallData)], na.rm = TRUE),
         incorrect_counts = sum(counts[!grepl(RefBase, BaseCallData)], na.rm = TRUE)) %>%
  ungroup() %>%
  select(Position, RefBase, TotalReads, correct_counts, incorrect_counts) %>%
  distinct()

# Define output file based on sample_id
output_file <- paste0("bam_read_count_analysis_", sample_id, ".csv")

# Save the result to a file
readr::write_csv(result, output_file)

# Print the result for inspection
cat("Processed results saved to", output_file, "\n")
