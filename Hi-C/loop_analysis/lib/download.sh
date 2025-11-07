#!/bin/bash

names=("$@")

for name in "${names[@]}";do
	~/software/sratoolkit.2.5.0-1-centos_linux64/bin/fastq-dump --split-files --gzip $name
#	echo $name
done
