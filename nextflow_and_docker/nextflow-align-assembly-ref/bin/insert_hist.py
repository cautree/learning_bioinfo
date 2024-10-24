#!/opt/anaconda3/bin/python

import pandas as pd
import os
import sys

date = sys.argv[1]



paths = [path for path in sorted(os.listdir('.')) if path.endswith('.insert_hist.csv')]
paths = sorted(paths)

df = pd.DataFrame([], columns = ['read_length'])
data = []

for path in paths:

    samp = path.split('/')[-1].split('_')[1:3]
    samp = '_'.join(samp).replace('.insert','')
    print(samp)

    # read in idxstats file
    tmp = pd.read_csv(path, header = None, names = [samp,'read_length'])
    
    # combine
    df = df.merge(tmp, how = 'outer')
    
    # max length
    data += [[samp, tmp.read_length.max()]]


df = df.sort_values('read_length').fillna(0)

cols = sorted(list(df.columns))
cols = [cols[-1]] + cols[:-1]

df[cols].to_csv(date + '_MinION.insert_hist.csv', index = False)

pd.DataFrame(data, columns = ['sample','read_length']).to_csv(date + '_MinION.insert_max.csv' , index = False)

