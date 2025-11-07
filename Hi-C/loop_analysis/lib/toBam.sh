#!/bin/bash

#This program take 1 command line argument:
#ARG1: experiment name/file name. eg. SRR1802420

exp=$1           #experiment name
seq=`gunzip $exp\_1.fastq.gz | head | sed -n '2p'`      #get 2nd line (which is the sequence read) 
of the fastq file
let trlen=${#seq}-36    #calculate trim length
echo $trlen
pa=~/HiC/lib     #path of perl programs

# bowtie mapping, ONE CPU each process
hg18=/mnt/NFS/geneITS0/JinLab/fxj45/Illumina_iGenomes/Homo_sapiens/UCSC/hg18/Sequence/BowtieIndex/genome # bowtie index for hg18
cat $exp\_1.fastq.gz | gunzip | bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $hg18 - $exp\_1.sam &
cat $exp\_2.fastq.gz | gunzip | bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $hg18 - $exp\_2.sam &

# wait till finish
wait

# SAM files into paired-end BAM files
rm $exp\*.gz
hg18=/mnt/NFS/geneITS0/JinLab/fxj45/GenebankDB/hg18/hg18.fa.fai      #sam index
# Count the total number of reads. cat command may take too much disk operation
echo Total reads count for $exp is `cat $exp\_1.sam | grep -vE ^@ | wc -l` >> summary.total.read_count
# merge SAM files into paired-end BAM
$pa/pairing_two_SAM_reads.pl $exp\_1.sam $exp\_2.sam | samtools view -bS -t $hg18 -o - - > $exp.bam &
# wait till finish
wait


# sort and remove duplicate
rm $exp\*.sam
# Count total number of aligned read pairs
echo Uniquely mapped read pairs for $exp is `samtools view $exp.bam | wc -l` >> summary.total.read_count &
samtools merge - SRR*.bam | samtools sort -o - - | samtools view - | $pa/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $hg18 -o - - > GMstanford.rep1.merged.sorted.nodup.bam
# Count final total reads without PCR duplication
echo Total non-duplicated read pairs is `samtools view GMstanford.rep1.merged.sorted.nodup.bam | wc -l` >> summary.total.read_count

