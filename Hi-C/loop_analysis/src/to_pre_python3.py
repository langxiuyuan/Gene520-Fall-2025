#!/usr/bin/python3

import sys

def find_loc(strand,frag,dic):
	
	return "0" + "\t"+dic[frag][0]+"\t"+dic[frag][1]+"\t"+frag.split('_')[1]
#		return " " + "\t"+dic[frag][0]+"\t"+dic[frag][2]+"\t"+frag.split('_')[1]
dic={}
bed=open(sys.argv[1])
for line in bed.readlines():
	chr,start,end,id=line.rstrip().split('\t')[0:4]
	dic[id]=[chr[3:],start,end]
bed.close()

for line in sys.stdin:
	frag1,frag2,reads=line.rstrip().split('\t')[0:3]
	
	id1, id2 = map(lambda x:int(x.split('_')[1]),[frag1,frag2])
	if id1 < id2:
	#strand1=frag1[-1]
		strand1='1'
		strand2='1'
	#frag1=frag1[0:-1]
	#strand2=frag2[-1]
        #frag2=frag2[0:-1]
		print(find_loc(strand1,frag1,dic)+"\t"+find_loc(strand2,frag2,dic)+"\t"+reads)
	
