#!/usr/bin/env python3

import os
import pandas as pd
import sys


output_path = sys.argv[1]

#artifact.error_metrics.txt
#artifact.error_metrics.txt
#artifact.error_metrics.txt
paths = [path for path in sorted(os.listdir('.')) if path.endswith('artifact.error_metrics.txt')]
print(paths)



df = pd.DataFrame([])

for path in paths:
    samp = path.replace('.artifact.error_metrics.txt','')
    tmp = pd.read_csv(path, sep = '\t', skiprows=1)
    tmp['sample_id'] = samp

    df = pd.concat( [df, tmp]) 

df = df.sort_values('sample_id')

##move sample_id to the first
cols = df.columns.tolist()
cols.insert(0, cols.pop(cols.index('sample_id')))
df = df.reindex(columns= cols)

df.to_csv(output_path , index =False)

