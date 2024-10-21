#!/usr/bin/env python3

import pandas as pd
import os
import sys

directory = sys.argv[1]
output_file = directory.split('/')[-1] + '.xlsx'
output_stats = directory.split('/')[-1] + '.stats.txt'

def column_widths(df, writer, sheetname):
    worksheet = writer.sheets[sheetname]
    for i, col in enumerate(df):
        widths = list(df[col].astype(str).str.len())
        col_width = max(widths + [len(df[col].name)]) + 1
        worksheet.set_column(i, i, col_width)
    return True

paths = os.listdir(directory + '/html/')
flowcell = [path for path in paths if path.startswith(('A', 'H', 'B', '0'))][0]
path = directory + '/html/' + [path for path in paths if path.startswith(('A', 'H', 'B', '0'))][0] + '/all/all/all/laneBarcode.html'

writer = pd.ExcelWriter(output_file)

# Flowcell summary output
df = pd.read_html(path)[1]
df['Flowcell ID'] = flowcell
df.to_excel(writer, sheet_name = 'Flowcell Summary', index = False)
column_widths(df, writer, 'Flowcell Summary')

# Top Unknown Barcodes output
df = pd.read_html(path)[3].dropna()
df.to_excel(writer, sheet_name = 'Top Unknown Barcodes', index = False)
column_widths(df, writer, 'Top Unknown Barcodes')

# Full Lane summary output
full_lane_path = directory + '/html/' + flowcell + '/all/all/all/lane.html'
df = pd.read_html(full_lane_path)[2]
df.to_excel(writer, sheet_name = 'Full Lane Summary', index = False)
column_widths(df, writer, 'Full Lane Summary')

# make separate sheets for each plate
# make final sheet for full (raw) output
raw = pd.read_html(path)[2]
cols = raw.columns

for project in sorted([p for p in set(raw.Project) if p != 'default']):
    
    df = raw[raw.Project == project].reset_index(drop = True)
    df['row_sort'] = df.index.astype(int) + 1
    df['column'] = df.Sample.str[-2:]
    df['row'] = df.Sample.str[-3]
    df['well'] = df.row + df.column
    df = df.sort_values(['column', 'row']).reset_index(drop = True)
    df['column_sort'] = df.index.astype(int) + 1

    try:    
        total_clusters = float(df['PF Clusters'].sum())
        df['% of the plate'] = df['PF Clusters'].apply(lambda x: x/total_clusters*100)
        df['% of the plate'] = df['% of the plate'].round(2)
    except:
        df['% of the plate'] = ''    

    df = df[list(cols) + ['well', 'row_sort', 'column_sort', '% of the plate']]
    
    df.to_excel(writer, sheet_name = project[:31], index = False)
    column_widths(df, writer, project[:31])

raw.to_excel(writer, sheet_name = 'Full Lane', index = False)    
column_widths(raw, writer, 'Full Lane')

# per-plate stats
plates = [path for path in sorted(os.listdir(directory + '/html/' + flowcell)) if path not in ['.DS_Store', 'all', 'default']]

clusters = pd.DataFrame()
stats = pd.DataFrame()

for plate in plates:
    plate_path = directory + '/html/' + flowcell + '/' + plate + '/all/all/lane.html'

    tmp = pd.read_html(plate_path)[1]
    tmp['Plate'] = plate
    tmp = tmp[['Plate', 'Clusters (Raw)', 'Clusters(PF)', 'Yield (MBases)']]
    clusters = clusters.append(tmp)

    tmp = pd.read_html(plate_path)[2]
    tmp['Plate'] = plate
    tmp = tmp[['Plate', 'Lane', 'PF Clusters', '% of thelane', '% Perfectbarcode',
       '% One mismatchbarcode', 'Yield (Mbases)', '% PFClusters',
       '% >= Q30bases', 'Mean QualityScore']]
    stats = stats.append(tmp)

clusters.to_excel(writer, sheet_name = 'Plate Summary - clusters', index = False)
column_widths(clusters, writer, 'Plate Summary - clusters')
stats.to_excel(writer, sheet_name = 'Plate Summary - stats', index = False)
column_widths(stats, writer, 'Plate Summary - stats')

writer.close()

# get stats for email
stats = raw.groupby('Project')['Yield (Mbases)'].sum().reset_index()
stats['Project'] = stats.Project.apply(lambda x: 'Undetermined' if x=='default' else x)
stats = stats.append(pd.DataFrame([['Total', stats['Yield (Mbases)'].sum()]], columns = ['Project', 'Yield (Mbases)']))

stats['Yield'] = stats['Yield (Mbases)']/1000
stats['Yield'] = stats.Yield.apply(lambda x: '%.3f' % x) + 'Gb'

stats[['Project', 'Yield']].to_csv(output_stats, index = False, header = False, sep = '\t')



