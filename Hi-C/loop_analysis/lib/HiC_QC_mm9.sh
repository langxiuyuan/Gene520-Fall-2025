#!/bin/bash

#ARG1: experiment name/file name. eg. SRR1802420

mm9=/mnt/NFS/homeGene/JinLab/fxj45/Illumina_iGenomes/Mus_musculus/UCSC/mm9/Sequence/BowtieIndex/genome
lib=~/lib/HiC
bowtie=/mnt/NFS/homeGene/JinLab/xxl244/software/bowtie-1.1.2/bowtie

expt=$1
length=`head $expt.R1.fastq | tail -1 | wc -m`
let length=$length-1
if [[ $length -gt 36 ]]
then
	rdlen=36
	let trlen=$length-36		#trim length. $2 need to be the length of sequence reads
	# bowtie mapping, ONE CPU each process
	$bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $mm9 $expt.R1.fastq $expt.R1.sam &
	$bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $mm9 $expt.R2.fastq $expt.R2.sam &
else
	rdlen=$length
	$bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $mm9 $expt.R1.fastq $expt.R1.sam &
        $bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $mm9 $expt.R2.fastq $expt.R2.sam &
fi
# wait till finish
wait

# SAM files into paired-end BAM files
mm9=/mnt/NFS/homeGene/JinLab/fxj45/GenebankDB/mm9/mm9.fa.fai
# Count the total number of reads. cat command may take too much disk operation
echo Total reads count for $expt is `cat $expt.R1.sam | grep -vE ^@ | wc -l` >> summary.total.read_count
# merge SAM files into paired-end BAM
$lib/pairing_two_SAM_reads.pl $expt.R1.sam $expt.R2.sam | samtools view -bS -t $mm9 -o - - > $expt.bam &
# wait till finish
wait

# sort and remove duplicate
# Count total number of aligned read pairs
echo Uniquely mapped read pairs for $expt is `samtools view $expt.bam | wc -l` >> summary.total.read_count &
samtools sort -o $expt.bam $expt.sorted | samtools view - | ~/lib/HiC/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $mm9 -o - - > $expt.sorted.nodup.bam
# Count final total reads without PCR duplication
echo Total non-duplicated read pairs is `samtools view $expt.sorted.nodup.bam | wc -l` >> summary.total.read_count

echo -ne read_summary_file\\ttotal_inter\\ttotal_intra\\ttotal_samestrand\\tloop_samestrand\\tloop_inward\\tloop_outward\\n >> summary.frag_loop.read_count
# cis- read pairs to fragment pairs, also print the stats
samtools view $expt.sorted.nodup.bam | cut -f2-8 | $lib/bam_to_temp_HiC.pl >$expt.temp
$lib/reads_2_cis_frag_loop.pl ~/lib/ELPU/mm9.HindIII.frag.bed $rdlen $expt.loop.inward $expt.loop.outward $expt.loop.samestrand summary.frag_loop.read_count $expt $expt.temp &

