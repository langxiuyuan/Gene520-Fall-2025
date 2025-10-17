#!/bin/bash

#fastq-dump=~/software/sratoolkit.2.5.0-1-centos_linux64/bin/fastq-dump
lib=~/lib
jin=/mnt/NFS/geneITS0/JinLab/fxj45
www=$jin/WWW/xxl244/bigwig/
hg18=$jin/GenebankDB/hg18/hg18.fa.fai


#----------------sra file to fastq then to sam file--------------------
for file in `ls *.sra`;
do
        ~/software/sratoolkit.2.5.0-1-centos_linux64/bin/fastq-dump $file     #sra -> fastq
done

for file in `ls *.fastq`;
do
        $lib/bowtie_fastq.pl hg18 8 $file     #fastq -> sam
done

#---------------Sam file to sorted mapped bam file----------------
for file in `ls *.sam`;
do
        samtools view -bS -t $hg18 $file | samtools sort - ${file/.sam/}       #sam->sorted bam
        echo -ne ${file/.sam/} has `cat $file | wc -l` total reads.\\n >> summary.reads_count
done

for file in `ls *.bam`;
do
        samtools view -h -F 4 -b $file > $file.sorted   #remove unmapped reads
done

for file in `ls *.bam.sorted`;
do
	mv "$file" "${file/.bam.sorted/.sorted.bam}"    #rename
done


#---------------Sorted bam file to bed,wig and bigwig file-----------------------------
for file in `ls *.sorted.bam`;
do
        echo -ne ${file/.sorted.bam/} has `samtools view $file | wc -l` mapped reads.\\n >>summary.reads_count
        bedtools bamtobed -i $file | perl -ne 'chomp;split;$_[3]=".";$_[4]=1;print join("\t",@_)."\n";' | $lib/sorted_bed_merge_redundant_lines_V2.pl > $file.monoclonal.bed     #bam -> bed

        $lib/extend_reads_from_start.pl $file.monoclonal.bed 300 hg18 | $lib/UCSC_2_normal.pl | sort -k1,1 -k2,2n -k3,3n | $lib/sorted_bed_2_wig_no_strand.pl | $lib/normal_2_UCSC.pl > ${file/.sorted.bam/}.wig.300bp  #bed -> wig

        $HOME/software/wigToBigWig ${file/.sorted.bam/}.wig.300bp $jin/GenebankDB/hg18/chrom.sizes ${file/.sorted.bam/}.bw  #wig ->bigwig
done


#--------------------organize files------------------------------------------
wait
mkdir bam
mkdir monoclonal_bed
mkdir wig_300bp
mkdir bigwig

mv *.sorted.bam bam/
mv *.monoclonal.bed monoclonal_bed/
mv *.wig.300bp wig_300bp/
mv *.bw bigwig/

tar -czvf $name.tar.gz *.fastq
wait

#rm -r *.bam *.sam *.fastq

#------------create tracks for genome browser----------------------------------------
current=`pwd`
cd $current/bigwig
for file in `ls *.bw`;
do
        name=`date +%m_%d_%Y-%H_%M_%S-%N`
        cp $file $www/$name.bw
        rm $file
        ln -s $www/$name.bw $file       #create symbolic link
        echo track type=bigWig name="$file" description="$file" visibility=full autoScale=on maxHeightPixels=100:20:15 bigDataUrl=http://evolution.gene.cwru.edu/~fxj45/xxl244/bigwig/$name.bw color=0,0,0 >> enhancer.bigwig.track_info.list
done
