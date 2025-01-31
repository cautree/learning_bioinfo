#!/Users/yanyan/opt/miniconda3/bin/python
import glob
import sys
import pandas as pd
import os


out_name = sys.argv[1]

files=glob.glob('*.txt')
print(files)

col_names = ["qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", 
"evalue", "bitscore", "filename"]
info=pd.DataFrame(columns= col_names)

for f in sorted(files):

    filename=f.split('.')[0]
    print(filename)

    try:
        df1=pd.read_table(f, sep="\t", names=col_names)
        df1["filename"] = filename

       
    except:
        columns = col_names

        data =   ['']*12+  [filename]
        df1 = pd.DataFrame([data], columns = columns)

    info= pd.concat([info, df1], ignore_index=True)
    
#info = info[info["pair_id"].str.strip() != 'pair_id']    
info.to_csv(out_name + '.csv', index=False)




