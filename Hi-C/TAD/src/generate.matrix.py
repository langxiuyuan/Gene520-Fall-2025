#!/bin/python

import sys
import os
import pandas as pd
import numpy as np
path=sys.argv[1]
genome=sys.argv[2]
enzyme=sys.argv[3]
chr=sys.argv[4]
beg=int(sys.argv[5])
end=int(sys.argv[6])
prefix=sys.argv[7]
#filename='{0}_{1}_anchors_avg.bed'.format(genome,enzyme)
filename='~/stag2KO/TAD/ref/hg19.genome_split_40k'
try:
	bed=pd.read_csv(filename,sep='\t',names=['chr','beg','end','id'],usecols=['chr','beg','end','id'])
except:
	bed=pd.read_csv(filename,sep='\t',names=['chr','beg','end','id','length'],usecols=['chr','beg','end','id'])
#bed['beg']=map(lambda x:int(x),bed['beg'])
bed['end']=bed['end'].astype('int64')
bed['beg']=bed['beg'].astype('int64')

bed=bed.loc[(bed['chr']==chr) & (bed['beg'] >= beg) & (bed['end'] <= end)]
bed=bed['id'].to_list()


try:
	df1=pd.read_csv(path+'/'+chr+'.bin_loop',sep='\t',names=['a1','a2','ratio'])
except:
	df1=pd.read_csv(path+'/anchor_2_anchor.loop.'+chr,sep='\t',names=['a1','a2','obs','expt'])


t=df1['a1'].isin(bed) & df1['a2'].isin(bed)
df1=df1.loc[t]

df1.to_csv(prefix,sep='\t',index=False,header=False)

