import pandas as pd
import matplotlib.ticker as mticker 
import sys
import os

input_file = sys.argv[1]
res = sys.argv[2]
genome = sys.argv[3]


output_file = input_file.replace('merged.PC1.label','PC1_labels_for_track.txt')

loop_file = pd.read_csv(input_file,sep = '\t', header = None, names = ['bin','label','PC1_values'])
genome_bin = pd.read_csv(f'/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/bin_path/{genome}/{genome}.genome_split_{res}', sep = '\t', header = None, names = ['chr','start','end','bin'])

genome_bin['chr_bin'] = genome_bin['chr'] + '_' + genome_bin['bin']
column_order = ['chr_bin','start', 'end', 'chr']
genome_bin = genome_bin[column_order]

# get the start and end of each anchor
bin_info = {}
for index, row in genome_bin.iterrows():
    bin_info[row['chr_bin']] = (row['chr'], row['start'],row['end'])

loop_file['chr'] = loop_file['bin'].map(lambda x:bin_info[x][0])
loop_file['start'] = loop_file['bin'].map(lambda x:bin_info[x][1])
loop_file['end'] = loop_file['bin'].map(lambda x:bin_info[x][2])

order = ['chr','start','end','PC1_values']
loop_file = loop_file[order]
loop_file.to_csv(output_file, sep = '\t', header  = False, index = False)
