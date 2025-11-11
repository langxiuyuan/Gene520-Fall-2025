#!/bin/python


import pandas as pd
import sys
import os


dic={}

with open(sys.argv[1],'r') as f:

	for line in f:
		chr, frag, bin = line.rstrip().split('\t')[0:3]
		anchor = chr + "_" + bin
		if frag not in dic:
			dic[frag]=[]
		dic[frag].append(anchor)
out = {}

with open(sys.argv[2],'r') as f:
	for line in f:
		f1, f2, reads= line.rstrip().split('\t')[0:3]
		a1 = dic[f1]
		a2 = dic[f2]
		for i in a1:
			for j in a2:
				index=i+':'+j
				if index not in out:
					out[index]=0
				out[index] += int(reads)

f.close()

for index in out:
	print index + '\t' + str(out[index])




















					
