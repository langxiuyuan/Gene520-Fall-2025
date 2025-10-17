#!/usr/bin/python

import sys

dic={}
file=open(sys.argv[1])
for line in file.readlines():
	elems=line.rstrip().split('\t')
	frag1='\t'.join(elems[0:4])
	frag2='\t'.join(elems[4:8])
	count=elems[8]
	if frag1+','+frag2 not in dic and frag2+','+frag1 not in dic:
		dic[frag1+','+frag2]=int(count)
	elif frag1+','+frag2 in dic:
		dic[frag1+','+frag2]=dic[frag1+','+frag2]+int(count)
	elif frag2+','+frag1 in dic:
		dic[frag2+','+frag1]=dic[frag2+','+frag1]+int(count)
file.close()

xym={}
for pair in dic:
	frag1,frag2=pair.split(',')
	chr1,start1,end1,strand1=frag1.split('\t')
	chr2,start2,end2,strand2=frag2.split('\t')
	if chr1=='chrX' or chr2=='chrX' or chr1=='chrY' or chr2=='chrY' or chr1=='chrM' or chr2=='chrM':
		xym[pair]=dic[pair]	
	elif int(chr1[3:])>int(chr2[3:]):
		print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)
	elif int(chr1[3:])<int(chr2[3:]):
		print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)
	else:	#chr1==chr2
		if int(start1)>=int(start2):
			print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)
		else:
			print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)

for pair in xym:
	frag1,frag2=pair.split(',')
        chr1,start1,end1,strand1=frag1.split('\t')
        chr2,start2,end2,strand2=frag2.split('\t')
	if chr1[3:].isdigit():
		print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)
	elif chr2[3:].isdigit():
		print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)
	elif chr1==chr2:
		if int(start1)>=int(start2):
                        print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)
                else:
                        print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)
	else:
		if chr1=='chrX':
			print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)
		elif chr2=='chrX':
			print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)			
		elif chr1=='chrY':
			print frag1+'\t'+frag2+'\t'+str(dic[pair]/2)
		elif chr2=='chrY':
			print frag2+'\t'+frag1+'\t'+str(dic[pair]/2)

