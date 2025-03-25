process {
    withName: GAWK {
        ext.args2 = "'{ total += \$3 } END { print total/NR }'"
        ext.suffix = "txt"
    }
    withName: SAMTOOLS_VIEW {
        ext.args = "--write-index"
    }
}


s3://seqwell-dev/work/20250324_Admera_Health/work/18/bbe804
s3://seqwell-dev/work/20250324_Admera_Health/work/10/837679
s3://seqwell-dev/work/20250324_Admera_Health/work/05/d07168
s3://seqwell-dev/work/20250324_Admera_Health/work/58/cfd901
s3://seqwell-dev/work/20250324_Admera_Health/work/3e/88f536
s3://seqwell-dev/work/20250324_Admera_Health/work/64/5040da
s3://seqwell-dev/work/20250324_Admera_Health/work/e6/11239f
s3://seqwell-dev/work/20250324_Admera_Health/work/9c/6904e0


s3://seqwell-dev/work/20250324_Admera_Health/work/18/bbe804eaf9b91294cc701e3ac23e70/
s3://seqwell-dev/work/20250324_Admera_Health/work/10/83767946f1cb977a94668a11b3eb19/
s3://seqwell-dev/work/20250324_Admera_Health/work/05/d071685cf58756ce41598d698d27c7/
s3://seqwell-dev/work/20250324_Admera_Health/work/58/cfd901a99b090783d473f4f9321211/
s3://seqwell-dev/work/20250324_Admera_Health/work/3e/88f53627b17f031fb62d7e7f696606/
s3://seqwell-dev/work/20250324_Admera_Health/work/64/5040da2ba42841d6e5e95dac013ec8/
s3://seqwell-dev/work/20250324_Admera_Health/work/e6/11239fcd4412210c604aa7be9d1133/
s3://seqwell-dev/work/20250324_Admera_Health/work/9c/6904e0b8e8154668747c4bdb56dced/