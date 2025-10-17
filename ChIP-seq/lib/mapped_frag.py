#!/usr/bin/python

import sys

num=len(sys.argv)
dic={}

file=open(sys.argv[1],'r')
for line in file.readlines():
	line=line.rstrip()
	#strand=strand.lstrip()
	dic[line]=""
file.close()

for i in range(2,num):
	file=open(sys.argv[i],'r')
	while True:
		line=file.readline()
		if not line:
			break
		anchor1,beg1,str1,frag1,anchor2,beg2,str2,frag2=line.rstrip().split('\t')
		if frag1+', '+str1 not in dic:
			dic[frag1+', '+str1]=""
		if frag2+', '+str2 not in dic:
                        dic[frag2+', '+str2]=""
	file.close()

for key in dic:
	print key
