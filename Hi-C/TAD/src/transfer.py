#!/bin/python

import sys

for line in sys.stdin:

	chr, beg, end = line.rstrip().split('\t')
	if int(beg)>=20000 and int(end)>=20000:	
		print '\t'.join([chr, str(int(beg)-20000),str(int(beg)+20000)])
		print '\t'.join([chr, str(int(end)-20000),str(int(end)+20000)])
	if int(end)<20000:
		print '\t'.join([chr, str(0),str(40000)])

