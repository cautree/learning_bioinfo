#!/usr/bin/env python3

import os
import pandas as pd
import sys

output_path = sys.argv[1]

paths = [path for path in sorted(os.listdir('.')) if path.endswith('.txt')]
print(paths)

# define the output file name
writer = pd.ExcelWriter(output_path, engine = 'xlsxwriter')

# create list of file extensions and dict of sheetnames for excel file
endings = ['.align.txt',
          '.insert.txt',
           '.md.txt',
           '.GC_sum.txt', 
           '.wgs.txt',
           '.hybrid.txt']

sheetnames = ['CollectAlignmentSummaryMetrics',
             'CollectInsertSizeMetrics',
              'MarkDuplicates',
              'CollectGcBiasMetrics',
              'CollectWgsMetrics',
              'CollectHsMetrics']

sheet_dict = dict(zip(endings, sheetnames))

# iterate through endings 
for ending in endings:
    df = pd.DataFrame([])
    for path in [path for path in paths if path.endswith(ending)]:
        # for each path with extension, create sample name
        sample = path.replace(ending,'').split('/')[-1]

        # read in data from that path
        try:
            tmp = pd.read_csv(path, delimiter='\t', skiprows=6, nrows=1)
            tmp = tmp.T
            tmp.columns = [sample]
        except:
            tmp = pd.DataFrame([], columns = [sample])

        # append data to dataframe
        df = df.merge(tmp, left_index=True, right_index=True, how='outer')

    # write each dataframe (one per extension) to a sheet in an excel file
    if len(df) > 0:
        df.T.sort_index().to_excel(writer, sheet_name = sheet_dict[ending][:30])

writer.close()



