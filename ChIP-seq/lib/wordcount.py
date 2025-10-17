#!/usr/bin/python

import sys

file=open(sys.argv[1],'r')
index=int(sys.argv[2])	#column index of the word need to be count

wordcount={}
for line in file.readlines():
	word=line.split('\t')[index].rstrip()
    	if word not in wordcount:
        	wordcount[word] = 1
    	else:
        	wordcount[word] += 1
file.close()

for k,v in wordcount.items():
	print k+'\t'+str(v)
