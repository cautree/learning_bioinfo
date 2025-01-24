


params.run_list="2024aug-oct-keep.csv"

run_list_ch = channel.fromPath(params.run_list)
                     .splitCsv()
                     .flatten()

process bscp {
  
     container '512431263418.dkr.ecr.us-east-1.amazonaws.com/bcl2fq'

     publishDir path: "s3://seqwell-basespace/2024/", pattern: "*.tar.gz"
     publishDir path: "s3://seqwell-basespace/2024/", pattern: "*.csv",  optional: true

     input:
     val(bcl_name)  from run_list_ch
   

     output:
     path("*.BCL.tar.gz") 
     path("*.csv") 

     """
     
   
     
     bs download run --exclude="*jpg" --name ${bcl_name} -o ${bcl_name}_BCL
     if [ -f ${bcl_name}_BCL/SampleSheet.csv ]; then
      cp ${bcl_name}_BCL/SampleSheet.csv  ${bcl_name}.SampleSheet.csv
    else
      touch ${bcl_name}.SampleSheet.csv
     fi
     tar czfv ${bcl_name}.BCL.tar.gz ${bcl_name}_BCL
     

     
     """
}




