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

#1       2686    T       59      =:0:0.00:0.00:0.00:0:0:0.00:0.00:0.00:0:0.00:0.00:0.00  A:0:0.00:0.00:0.00:0:0:0.00:0.00:0.00:0:0.00:0.00:0.00  C:0:0.00:0.00:0.00:0:0:0.00:0.00:0.00:0:0.00:0.00:0.00 G:0:0.00:0.00:0.00:0:0:0.00:0.00:0.00:0:0.00:0.00:0.00  T:59:60.00:36.93:60.00:28:31:0.00:0.00:0.00:0:0.00:0.00:0.00  N:0:0.00:0.00:0.00:0:0:0.00:0.00:0.00:0:0.00:0.00:0.00
# Rename the columns for clarity
colnames(bam_data) <- c("Index","Position", "RefBase", "TotalReads", "OtherColumns","BaseCall_A", "BaseCall_C", "BaseCall_G", "BaseCall_T", "BaseCall_N" )

# Nest the base calls (columns 4 to 8) into a single list-column using tidyr::nest()
result <- bam_data %>%
  select(Position, RefBase, TotalReads, BaseCall_A, BaseCall_C, BaseCall_G, BaseCall_T, BaseCall_N) %>%
  tidyr::gather(BaseCall_A:BaseCall_N, key="column", value = "column_info" ) %>% 
  dplyr::mutate( counts = stringr::str_extract_all( column_info, "[A-Z]:[0-9]{1,}")) %>% 
  dplyr::mutate( counts = stringr::str_replace_all( counts, "(A|T|C|G|N):", "")) %>% 
  dplyr::mutate( counts = as.numeric(counts)) %>% 
  tidyr::nest(-Position) %>% 
  dplyr::mutate( data2 = purrr::map(.$data, function(x){
    
    x_correct = x %>% 
      dplyr::filter( grepl(RefBase, column_info ) )
    
    x_incorrect = x %>% 
      dplyr::filter(! grepl(RefBase, column_info ) )
    
    n_correct_counts = sum(x_correct$counts, na.rm = T)
    n_incorrect_counts = sum(x_incorrect$counts, na.rm = T)
    
    
    res = x %>% 
      dplyr::mutate( correct_counts = n_correct_counts, 
                     incorrect_counts = n_incorrect_counts
      ) %>% 
      dplyr::select( -column, -column_info, -counts) %>% 
      dplyr::distinct()
    
    return( res)
  })) %>% 
  dplyr::select( Position, data2) %>% 
  tidyr::unnest()


# Define output file based on sample_id
output_file <- paste0("bam_read_count_analysis_", sample_id, ".csv")

# Save the result to a file
readr::write_csv(result, output_file)

# Print the result for inspection
cat("Processed results saved to", output_file, "\n")
