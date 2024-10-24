#!/usr/bin/env python3

import os
import pandas as pd
import sys

output_prefix = sys.argv[1]
# 20211109_iSeq_hg38

insert_out = output_prefix + '.insert.csv'

paths = [path for path in sorted(os.listdir('.')) if path.endswith('.insert.csv')]
print(paths)

df = pd.DataFrame(range(1,1001), columns = ['insert_size'])

for path in paths:
    samp = path.replace('.insert.csv','')

    try:
        tmp = pd.read_csv(path, usecols = [0,1], comment = '#')
        tmp.columns = ['insert_size', samp]
        df = df.merge(tmp, how = 'left').fillna(0)
    except:
        tmp = pd.DataFrame(range(1,1001), columns = ['insert_size'])
        tmp[samp] = 0

df.to_csv(insert_out, float_format='%.0f', index = False)

