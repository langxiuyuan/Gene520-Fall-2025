#!/bin/bash

expt=$1

hg19=~/Reference_Indexes/hg19/Homo_sapiens/UCSC/hg19/Sequence/BowtieIndex/genome
lib=~/lib/HiC
bowtie=~/software/bowtie-1.1.2/bowtie

length=`head $expt.R1.fastq | tail -1 | wc -m`
let length=$length-1
if [[ $length -gt 36 ]]
then
        let trlen=$length-36             #trim length. $2 need to be the length of sequence reads
        # bowtie mapping, ONE CPU each process
	rdlen=36
        $bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $hg19 $expt.R1.fastq $expt.R1.sam &
        $bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $hg19 $expt.R2.fastq $expt.R2.sam &
else
	rdlen=$length
        $bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $hg19 $expt.R1.fastq $expt.R1.sam &
        $bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $hg19 $expt.R2.fastq $expt.R2.sam &
fi

wait

hg19=~/Reference_Indexes/hg19/Homo_sapiens/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa.fai
echo Total reads count for $expt is `cat $expt.R1.sam | grep -vE ^@ | wc -l` >> summary.total.read_count &
$lib/pairing_two_SAM_reads.pl $expt.R1.sam $expt.R2.sam | samtools view -bS -t $hg19 -o - - > $expt.bam &
wait

echo Uniquely mapped read pairs for $expt is `samtools view $expt.bam | wc -l` >> summary.total.read_count &
samtools sort $expt.bam | samtools view - | ~/lib/HiC/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $hg19 -o - - > $expt.sorted.nodup.bam
echo Total non-duplicated read pairs for $expt is `samtools view $expt.sorted.nodup.bam | wc -l` >> summary.total.read_count

echo -ne read_summary_file\\ttotal_inter\\ttotal_intra\\ttotal_samestrand\\tloop_samestrand\\tloop_inward\\tloop_outward\\n >> summary.frag_loop.read_count
samtools view $expt.sorted.nodup.bam | cut -f2-8 | $lib/bam_to_temp_HiC.pl >$expt.temp
$lib/reads_2_cis_frag_loop.pl ~/lib/ELPU/hg19.HindIII.frag.bed $rdlen $expt.loop.inward $expt.loop.outward $expt.loop.samestrand summary.frag_loop.read_count $expt $expt.temp
#gzip $expt.R?.fastq &


