#!/usr/bin/python

import sys

dic={}
file=open(sys.argv[1])
while True:
	line=file.readline()
	if not line:
		break
	#chr1,start1,strand1,chr2,start2,strand2,len1,len2=line.rstrip().split('\t')
	elems=line.rstrip().split('\t')
	pair='\t'.join(elems[0:6])
	if pair not in dic:
		dic[pair]=0
	dic[pair]=dic[pair]+1
file.close()

for pair in dic:
	chr1,start1,strand1,chr2,start2,strand2=pair.split('\t')
	#if strand1=='+':
	end1=str(int(start1)+34)
	#else:
	#	end1=start1
	#	start1=str(int(end1)-34)
	#if strand2=='+':
        end2=str(int(start2)+34)
        #else:
        #        end2=start2
        #        start2=str(int(end2)-34)
	print chr1+'\t'+start1+'\t'+end1+'\t'+strand1+'\t'+chr2+'\t'+start2+'\t'+end2+'\t'+strand2+'\t'+str(dic[pair])
