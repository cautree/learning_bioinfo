


process bscp {

     //container '512431263418.dkr.ecr.us-east-1.amazonaws.com/bcl2fq'
     
     publishDir "all_runs_names", mode: "copy", pattern: "*.csv"
     
     output:
     path("*.csv")

     """
     
     bs list run -f csv  > run.list.csv
     
     """
}

workflow{
  
  bscp()
}