#!/opt/anaconda3/bin/python

import pandas as pd

path = '20220223_MiSeq-Sharkboy.csv'
output = '20220223_MiSeq-Sharkboy_rc.csv'

def RC(seq):
    # return reverse complement of sequence (string input/output)
    nucl = dict(zip('ACGT', 'TGCA'))
    return ''.join([nucl[n] for n in reversed(seq)])

df = pd.read_csv(path, skiprows = 15)

df['index2'] = df.index2.str.strip().map(RC)

df[['Sample_Name','Sample_Id','index2','Sample_Project']].to_csv(output, index = False)

