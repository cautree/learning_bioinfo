#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

FUN <- readRDS(args[1]);
input = readRDS(args[2]);
output = FUN(
  singleCell_data_input=input[[1]], savePath=input[[2]], tmpDirGC=input[[3]]
);
saveRDS(output, args[3])