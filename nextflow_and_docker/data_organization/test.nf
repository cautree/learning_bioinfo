params.run_list="2024aug-oct-keep.csv"

run_list_ch = channel.fromPath(params.run_list)
                     .splitCsv()
                     
                     
run_list_ch.view()