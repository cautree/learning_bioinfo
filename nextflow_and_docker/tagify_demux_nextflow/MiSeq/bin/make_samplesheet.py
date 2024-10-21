#!/usr/bin/env python3
import datetime as dt
import sys
import pandas as pd
import numpy as np
import os


# write_samplesheets save the samplesheets after correcting index length for mixed
def write_samplesheet(full_sheet, samplesheet_path, read_length, run):
    date = dt.date.today()
    header = ['[Header],,,,,,,,,',
              'IEMFileVersion,4,,,,,,,,',
              'Investigator Name,seqWell,,,,,,,,',
              'Experiment Name,plexwell,,,,,,,,',
              'Date,' + str(date) + ',,,,,,,,',
              'Workflow,GenerateFASTQ,,,,,,,,',
              'Application,MiSeq FASTQ Only,,,,,,,,',
              'Assay,Nextera XT,,,,,,,,',
              'Description,,,,,,,,,',
              'Chemistry,Amplicon,,,,,,,,',
              read_length,
              read_length,
              '[Reads],,,,,,,,,',
              '[Settings],,,,,,,,,',
              'Adapter,CTGTCTCTTATACACATCT,,,,,,,,',
              '[Data],,,,,,,,,',
              'Sample_ID,Sample_Name,Sample_Plate,Sample_Well,I7_Index_ID,index,I5_Index_ID,index2,Sample_Project,Description']

    f = open(samplesheet_path, 'wt')

    for line in header:
        f.write(line + '\n')

    index_lengths = full_sheet.index2.str.len().unique()
    if 10 in index_lengths and 8 in index_lengths:
        if run == 'miseq':
            full_sheet['index'] = full_sheet['index'].apply(lambda x: x + "AT" if len(x) == 8 else x)
            full_sheet['index2'] = full_sheet['index2'].apply(lambda x: x + "TC" if len(x) == 8 else x)
        else:
            full_sheet['index'] = full_sheet['index'].apply(lambda x: x + "AT" if len(x) == 8 else x)
            full_sheet['index2'] = full_sheet['index2'].apply(lambda x: x + "GT" if len(x) == 8 else x)

    full_sheet.to_csv(f, index=False, header=False)
    f.close()
    return samplesheet_path


# make_tag2 returns a samplesheet for one line of sequencing manifest using regular plexwell index.
def each_tag2(sample, path_tag2):
    # Import tag2/i5
    tag2 = pd.read_csv(path_tag2, sep='\t', dtype=str, names=['barcode', 'well'])

    samp_tag2 = sample.tag2
    # Remove the '0's at the beginning of the number, e.g., '008' -> '8'
    if samp_tag2.startswith('0'):
        samp_tag2 = str(int(samp_tag2))

    samp_plate = sample.plate
    samp_barcode = tag2[tag2.well == samp_tag2][['barcode']]

    # determine the tag1 depending on the tag1 information form the sample manifest, if n0, n1 ..., use new_tag1_i7, else, use tag1_i7.
    samp_tag1 = sample.tag1
    if samp_tag1.startswith('n'):
        samp_tag1 = samp_tag1[1:]
        tag1_file = 'new_tag1_i7.'
    elif samp_tag1.startswith('e'):
        samp_tag1 = samp_tag1[1:]
        tag1_file = 'expressplex_i7.'
    else:
        tag1_file = 'tag1_i7.'

    # Import tag1/i7
    tag1_path = tag1_file + samp_tag1 + '.txt'
    tag1 = pd.read_csv(tag1_path, sep='\t', dtype=str, names=['barcode', 'well'])

    # Generate samplesheet for a single line in the manifest
    ss = pd.DataFrame()
    ss['Sample_ID'] = samp_plate + '_' + tag1.well
    ss['Sample_Name'] = samp_plate + '_' + tag1.well
    ss['Sample_Plate'] = samp_plate
    ss['Sample_Well'] = tag1.well
    ss['I7_Index_ID'] = tag1.well
    ss['index'] = tag1.barcode
    ss['I5_Index_ID'] = samp_tag2
    ss['index2'] = samp_barcode.values[0][0]
    ss['Sample_Project'] = samp_plate + '_FASTQ'
    ss['Description'] = 'plexwell'

    return ss


# make_tag2 returns a samplesheet for one line of the sequencing manifest using UDI index.
def each_UDI(sample, path_UDI):
    ind_dict = {'1': range(24), '2': range(24, 48), '3': range(48, 72), '4': range(72, 96), '0': range(96),
                '1-A': range(24), '1-B': range(24, 48), '1-C': range(48, 72), '1-D': range(72, 96),
                '1-all': range(96),
                '2-A': range(96, 120), '2-B': range(120, 144), '2-C': range(144, 168), '2-D': range(168, 192),
                '2-all': range(96, 192),
                '3-A': range(192, 216), '3-B': range(216, 240), '3-C': range(240, 264), '3-D': range(264, 288),
                '3-all': range(192, 288),
                '4-A': range(288, 312), '4-B': range(312, 336), '4-C': range(336, 360), '4-D': range(360, 384),
                '4-all': range(288, 384)}

    samp_plate = sample.plate

    # import sample sheet and filter for the index
    ss = pd.read_csv(path_UDI, names=['Sample_Well', 'index', 'index2'])
    tag1 = sample.tag1
    indexes = [n for n in ind_dict[tag1]]
    ss = ss.loc[indexes]

    ss['Sample_ID'] = samp_plate + '_' + ss.Sample_Well
    ss['Sample_Name'] = samp_plate + '_' + ss.Sample_Well
    ss['Sample_Plate'] = samp_plate
    ss['I7_Index_ID'] = ss.Sample_Well
    ss['I5_Index_ID'] = ss.Sample_Well
    ss['Sample_Project'] = samp_plate + '_FASTQ'
    ss['Description'] = 'UDI'
    columns = ['Sample_ID', 'Sample_Name', 'Sample_Plate', 'Sample_Well',
               'I7_Index_ID', 'index', 'I5_Index_ID', 'index2', 'Sample_Project', 'Description']
    ss = ss[columns]

    return ss


# make_samplesheet returns the samplesheet for a plate manifest
def make_samplesheet(plate_path, path_UDI, path_beta_UDI, path_tag2):
    # Import the plate manifest
    samples = pd.read_csv(plate_path, delim_whitespace=True, dtype=str, names=['tag2', 'plate', 'tag1'])
    full_sheet = pd.DataFrame()

    # make samplesheet line by line
    for i in range(len(samples)):
        sample = samples.iloc[i]
        if sample.tag2 == 'UDI':
            s = each_UDI(sample, path_UDI)
        elif sample.tag2 == 'betaUDI':
            s = each_UDI(sample, path_beta_UDI)
        else:
            s = each_tag2(sample, path_tag2)

        # Append to the final samplesheet table
        full_sheet = full_sheet.append(s)

    return full_sheet


# make_custom return the samplesheet for a customized index input
def make_custom(plate_path, path_white, run):
    # import samplesheet
    ss = pd.read_csv(plate_path)

    # check for missing index
    groups = ss.groupby('Sample_Plate').count()
    for i in groups.index:
        n = groups.loc[i].Sample_Well
        for j in groups.loc[i].values:
            if j != 0 and j != n:
                raise ValueError('library ' + i + ' missing index')

    # fill in i5 or i7 with empty string
    if 'i7' not in ss.columns:
        ss['i7'] = ''
        ss['I7_Index_ID'] = ''
        ss['I5_Index_ID'] = ss['Sample_Well']
    elif 'i5' not in ss.columns:
        ss['i5'] = ''
        ss['I5_Index_ID'] = ''
        ss['I7_Index_ID'] = ss['Sample_Well']
    else:
        ss['I7_Index_ID'] = ss['Sample_Well']
        ss['I5_Index_ID'] = ss['Sample_Well']

    # import white list
    white_list = pd.read_csv(path_white)
    white_list.loc['Empty'] = ''

    # check for illegal characters in sample name
    # name_check = len(ss) - ss.Sample_Plate.str.match("^[0-9]{6}-[a-zA-Z0-9-]*$").sum()
    name_check = len(ss) - ss.Sample_Plate.str.match("^[a-zA-Z0-9][a-zA-Z0-9-_]*$").sum()
    if name_check:
        raise ValueError('Sample_Plate value not accepted')

    # check for illegal characters in sample well
    name_check = len(ss) - ss.Sample_Well.str.match("^[a-zA-Z0-9]*$").sum()
    if name_check:
        raise ValueError('Sample_Well value not accepted')

    # check for duplicated index
    if ss.duplicated(subset=['i5', 'i7']).any():
        raise ValueError('i7/i5 index pair duplicated')

    # check for white list
    if run == 'miseq':
        run2 = 'nextseq'
    else:
        run2 = 'miseq'
    # for i in ss.i7.values:
    #     if i not in white_list['i7'].values:
    #         raise ValueError('i7 index not in whitelist, check for spelling')
    # for i in ss.i5.values:
    #     if i not in white_list[run + '_i5'].values:
    #         if i in white_list[run2 + '_i5'].values:
    #             raise ValueError('using ' + run2 + ' i5 instead of ' + run + ' i5, check for orientation')
    #         else:
    #             raise ValueError('i5 index not in white list, check for spelling')

    # Sample_ID and Sample_Name will have the same value and identical for each sample
    ss['Sample_ID'] = ss['Sample_Plate'] + '_' + ss['Sample_Well']
    ss['Sample_Name'] = ss['Sample_Plate'] + '_' + ss['Sample_Well']
    if ss.Sample_Name.duplicated().any():
        raise ValueError('Sample_Name duplicate, check for Sample_Plate and Sample_Well duplications')

    ss['Sample_Project'] = ss['Sample_Plate'] + '_FASTQ'
    ss['Description'] = 'Custom'

    ss = ss[['Sample_ID', 'Sample_Name', 'Sample_Plate', 'Sample_Well', 'I7_Index_ID', 'i7', 'I5_Index_ID',
             'i5', 'Sample_Project', 'Description']]
    ss.columns = ['Sample_ID', 'Sample_Name', 'Sample_Plate', 'Sample_Well', 'I7_Index_ID', 'index', 'I5_Index_ID',
                  'index2', 'Sample_Project', 'Description']
    return ss

# parameter setting
plate = sys.argv[1]
# os.chdir('samplesheet/')
# plate = '20220405_MiSeq-Sharkboy.csv'
tag2 = 'MiSeq_tag2_i5.txt'
out_path = os.path.basename(plate).split('.')[0] + '_samplesheet.csv'
length = '150'
UDI = 'UDI-all.csv'
beta_UDI = 'betaUDIs.csv'
run_type = 'miseq'
white = 'whitelist.csv'

if 'miseq' not in plate.lower():
    tag2 = 'NextSeq_tag2_i5.txt'
    UDI = 'UDI-all.RC.csv'
    beta_UDI = 'betaUDIs.RC.csv'
    run_type = 'nextseq'

# run make_samplesheet if the input is a txt file
if plate.endswith('.txt'):
    sheet = make_samplesheet(plate_path=plate, path_UDI=UDI, path_beta_UDI=beta_UDI, path_tag2=tag2)
    write_samplesheet(full_sheet=sheet, samplesheet_path=out_path, read_length=length, run=run_type)

# run make_custom if the input is a custom csv file
if plate.endswith('.csv'):
    sheet = make_custom(plate_path=plate, path_white=white, run=run_type)
    write_samplesheet(full_sheet=sheet, samplesheet_path=out_path, read_length=length, run=run_type)
