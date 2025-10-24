#!/bin/bash
genome=$1

# set the lib and chromosome size file
lib=./lib
chrom_size=$lib/$genome.chrom.sizes

#--------map raw fastq file to reference genome----------------

for file in `ls *.fastq`;do
    perl $lib/bowtie_fastq.pl mm10 8 $file # fastq --> sam
done

#-----------Sam file to sorted mapped bam file----------------
ref=/mnt/vstor/courses/gene520/ChIP-seq/Ref/mm10.fa.fai/$genome.fa.fai

for file in `ls *.sam`;do
    samtools view -bS -t $ref $file | samtools sort -o ${file/.sam}.bam #sam->sorted bam
    wait
    samtools view -h -F 4 -b ${file/.sam}.bam > ${file/.sam}.sorted.bam #remove unmapped and low mappable reads
done

#------------Sorted bam file to bed,wig and bigwig file-----------------
for file in `ls *.sorted.bam`;do
    name=${file/.sorted.bam/}
    #
    echo -ne $name has `samtools view $file | wc -l` mapped reads.\\n >>summary.reads_count
    bedtools bamtobed -i $file | awk '{OFS="\t";print $1,$2,$3,".","1"}' | $lib/sorted_bed_merge_redundant_lines_V2.pl > $name.monoclonal.bed # remove PCR duplication
    wait
    echo -ne $name has `wc -l $name.monoclonal.bed` monoclonal reads >>summary.reads_count
    $lib/extend_reads_from_start.pl $name.monoclonal.bed 300 $genome | $lib/UCSC_2_normal.pl | sort -k1,1 -k2,2n -k3,3n | $lib/sorted_bed_2_wig_no_strand.pl | $lib/normal_2_UCSC.pl > $name.wig.300bp
    wait
    /mnt/vstor/courses/gene520/ChIP-seq/software/wigToBigWig $name.wig.300bp $chrom_size $name.bw #convert wig file to bigwig file
done

macs3 callpeak -t $name.sorted.bam -n $name

echo Done
