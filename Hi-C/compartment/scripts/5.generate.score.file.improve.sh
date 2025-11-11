#!/usr/bin/bash

genome=$1
#path=/mnt/rstor/genetics/JinLab/ssz20/zshanshan/heatmap_for_cis/
path=/mnt/jinstore/JinLab01/ssz20/zshanshan/heatmap_for_cis/
myPath=/mnt/jinstore/JinLab03/xxl1432/Reference/HiC/low_resolution/TSS.file/
outpath=$2
bin=$3

#H1.H3K4me3.100k.bed

if [ $genome == "hg19" ];then
	for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY;do
		$path/lib/compartment_calling.pl $myPath/hg19.TSS.${bin}.file $outpath/$chr.matrix.component > $outpath/$chr.bin.$bin.chip.freq.score
	done
fi

if [ $genome == "hg38" ];then
        for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY;do
                $path/lib/compartment_calling.pl $myPath/hg38.TSS.${bin}.file $outpath/$chr.matrix.component > $outpath/$chr.bin.$bin.chip.freq.score
        done
fi

if [ $genome == "mm10" ];then
        for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chrX chrY;do
                $path/lib/compartment_calling.pl $myPath/mm10.TSS.${bin}.file $outpath/$chr.matrix.component > $outpath/$chr.bin.$bin.chip.freq.score
        done
fi





