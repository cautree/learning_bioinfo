### Accuracy of Imputation ###

# prerequisites: working directory containing folder "WGS" and "impute"
# folder "WGS" contains csv files containing observed genotypes in additive coding ("*_R.raw") and accompanying bim files ("*.bim")
# folder "impute" contains csv files containing estimated alternate allele dosages ("*_R.raw") and accompanying bim files ("*.bim")


setwd("path_to_working_directoy")

raw_files_WGS <- list.files(path="./WGS",
                            pattern="*_R.raw",
                            full.names=TRUE,
                            recursive=FALSE)

bim_files_WGS <- list.files(path="./WGS",
                            pattern="*.bim",
                            full.names=TRUE,
                            recursive=FALSE)

raw_files_impute <- list.files(path="./impute",
                               pattern="*_R.raw",
                               full.names=TRUE,
                               recursive=FALSE)

bim_files_impute <- list.files(path="./impute",
                               pattern="*.bim",
                               full.names=TRUE,
                               recursive=FALSE)


# Compare lists of files of the folders "WGS" and "impute" manually to make sure they have the same order
raw_files_WGS
raw_files_impute
bim_files_WGS
bim_files_impute


# Loop

for(i in 1:length(raw_files_WGS)) {
  
  
  # read in files
  data_WGS <- read.csv(file=raw_files_WGS[i],
                       row.names=NULL,
                       header=TRUE,
                       sep="")
  
  bim_file_WGS <- read.csv(file=bim_files_WGS[i],
                           row.names=NULL,
                           header=FALSE,
                           sep="",
                           colClasses=c('character', 'character', 'integer', 'integer', 'character', 'character'))
  
  CHROM <- bim_file_WGS[,1]
  POS <- bim_file_WGS[,4]
  ID <- bim_file_WGS[,2]
  REF <- bim_file_WGS[,6]
  ALT <- bim_file_WGS[,5]
  
  WGS_info <- cbind(CHROM, POS, ID)
  WGS_complete <- cbind(WGS_info, data_WGS)
  
  
  data_impute <- read.csv(file=raw_files_impute[i],
                          row.names=NULL,
                          header=TRUE,
                          sep="")
  
  bim_file_impute <- read.csv(file=bim_files_impute[i],
                              row.names=NULL,
                              header=FALSE,
                              sep="",
                              colClasses=c('character', 'character', 'integer', 'integer', 'character', 'character'))
  
  CHROM <- bim_file_impute[,1]
  POS <- bim_file_impute[,4]
  ID <- bim_file_impute[,2]
  REF <- bim_file_impute[,6]
  ALT <- bim_file_impute[,5]
  impute_info <- cbind(CHROM, POS, ID)
  impute_complete <- cbind(impute_info, data_impute)
  
  # create subset of variants that are available both in WGS and in imputed data
  WGS_subset<-WGS_complete[WGS_complete$POS%in%impute_complete$POS,]
  
  # "visual" control of correct order - sum should equal rows/columns
  dim(WGS_subset)
  dim(impute_complete)
  
  
  # calcualte accuracy
  accuracy <- sapply(seq.int(dim(WGS_subset)[1]), 
                     function(i) cor(as.numeric(WGS_subset[i,5:ncol(WGS_subset)]), 
                                     as.numeric(impute_complete[i,5:ncol(impute_complete)]), 
                                     use = "pairwise.complete.obs"))
  
  
  # retrieve the POS and calculate MAF (the latter for both, WGS and imputed)
  POS<-WGS_subset$POS
  MAF_WGS<-(apply(WGS_subset[,5:ncol(WGS_subset)],1,sum))/((ncol(WGS_subset)-4)*2) # latter number is sample_num x 2 = allel_num, should be derived from dims
  MAF_imp<-(apply(impute_complete[,5:ncol(impute_complete)],1,sum))/((ncol(impute_complete)-4)*2)
  
  # switch those, where "MAF" it is the frequency of the major allele, to the minor allele
  MAF_WGS[MAF_WGS>0.5]<- 1-MAF_WGS[MAF_WGS>0.5]
  MAF_imp[MAF_imp>0.5]<- 1-MAF_imp[MAF_imp>0.5]
  accuracy_complete<-cbind(POS, MAF_WGS,MAF_imp,accuracy)
  
  
  # write files to disk
  write.table(accuracy_complete,
              paste(raw_files_impute[i],'csv',
                    sep = ".",
                    collapse = NULL),
              sep="\t",
              quote = FALSE,
              row.names = FALSE)
  
}


# result: csv files containing position, MAF (WGS and imputed data) and accuracy of imputation for all imputed variants seprately


# to calculate mean accuracy over all five validation groups, the five csv files were merged

# before calculating the mean accuracy of imputation, variants that were monomprphic in at least one group were then excluded
# (dataframe "acc"; columns "acc" may not be NA, columns "MAF_WGS" may not be 0)
acc_final <- acc[!is.na(acc[,4])&acc[,2]>0&acc[,3]>0&!is.na(acc[,7])&acc[,5]>0&acc[,6]>0&!is.na(acc[,10])&acc[,8]>0&acc[,9]>0&!is.na(acc[,13])&acc[,11]>0&acc[,12]>0&!is.na(acc[,16])&acc[,14]>0&acc[,15]>0,]

# subsequently, mean accuracies per variants (rows) and overall mean accuracy per chromosome were calculated 