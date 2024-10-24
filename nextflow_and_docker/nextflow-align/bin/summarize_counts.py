#!/usr/bin/env python3

import os
import pandas as pd
import sys

output_path = sys.argv[1]

paths = [path for path in sorted(os.listdir('.')) if path.endswith('.idxstats')]
print(paths)

species_dict = {
'MN908947.3':'SARS-CoV-2',
'J02459.1':'lambda',
'ecoli_REL606':'ecoli',
"NC_009428.1":"Rsphaeroides",
"CP000662.1":"Rsphaeroides",
"NC_009430.1":"Rsphaeroides",
"NC_009431.1":"Rsphaeroides",
"NC_009432.1":"Rsphaeroides",
"NC_009433.1":"Rsphaeroides",
"NC_010554.1":"Pmirabilis",
"NC_010555.1":"Pmirabilis",
"NC_000964.3":"Bacillus_subtilis",
"NC_026745.1":"Cryptococcus_neoformans",
"NC_026746.1":"Cryptococcus_neoformans",
"NC_026747.1":"Cryptococcus_neoformans",
"NC_026748.1":"Cryptococcus_neoformans",
"NC_026749.1":"Cryptococcus_neoformans",
"NC_026750.1":"Cryptococcus_neoformans",
"NC_026751.1":"Cryptococcus_neoformans",
"NC_026752.1":"Cryptococcus_neoformans",
"NC_026753.1":"Cryptococcus_neoformans",
"NC_026754.1":"Cryptococcus_neoformans",
"NC_026755.1":"Cryptococcus_neoformans",
"NC_026756.1":"Cryptococcus_neoformans",
"NC_026757.1":"Cryptococcus_neoformans",
"NC_026758.1":"Cryptococcus_neoformans",
"NC_018792.1":"Cryptococcus_neoformans",
"AE016830.1":"Enterococcus_faecalis",
"NC_000913.3":"Escherichia_coli",
"NC_010610.1":"Lactobacillus_fermentum",
"NC_003210.1":"Listeria_monocytogenes",
"AE004091.2":"Pseudomonas_aeruginosa",
"NC_001133.9":"Saccharomyces_cerevisiae",
"NC_001134.8":"Saccharomyces_cerevisiae",
"NC_001135.5":"Saccharomyces_cerevisiae",
"NC_001136.10":"Saccharomyces_cerevisiae",
"NC_001137.3":"Saccharomyces_cerevisiae",
"NC_001138.5":"Saccharomyces_cerevisiae",
"NC_001139.9":"Saccharomyces_cerevisiae",
"NC_001140.6":"Saccharomyces_cerevisiae",
"NC_001141.2":"Saccharomyces_cerevisiae",
"NC_001142.9":"Saccharomyces_cerevisiae",
"NC_001143.9":"Saccharomyces_cerevisiae",
"NC_001144.5":"Saccharomyces_cerevisiae",
"NC_001145.3":"Saccharomyces_cerevisiae",
"NC_001146.8":"Saccharomyces_cerevisiae",
"NC_001147.6":"Saccharomyces_cerevisiae",
"NC_001148.4":"Saccharomyces_cerevisiae",
"NC_001224.1":"Saccharomyces_cerevisiae",
"NC_003198.1":"Salmonella_enterica",
"NC_003384.1":"Salmonella_enterica",
"NC_003385.1":"Salmonella_enterica",
"NC_007795.1":"Staphylococcus_aureus",
"unmapped":"unmapped"
}


names = ['chrom', 'chrom_len', 'mapped', 'unmapped']

df = pd.DataFrame([], columns = ['chrom'])

for path in paths:
    samp = path.replace('.idxstats','').split('/')[-1]
    tmp = pd.read_csv(path, sep = '\t', names = names)
    tmp['chrom'] = tmp.chrom.replace("*", "unmapped")
    tmp[samp] = tmp.mapped + tmp.unmapped

    tmp['chrom'] = tmp.chrom.apply(lambda x: 'hg38' if x.startswith('chr') else x)
    tmp['chrom'] = tmp.chrom.map(species_dict).fillna(tmp['chrom'])
    tmp = tmp.groupby('chrom').sum().reset_index()

    df = df.merge(tmp[['chrom', samp]], how = 'outer')

df = df.sort_values('chrom')
df.index = df.chrom
df = df.drop('chrom', axis = 1)
df = df.T.sort_index()
df['total'] = df.sum(axis = 1)

df.to_csv(output_path)

