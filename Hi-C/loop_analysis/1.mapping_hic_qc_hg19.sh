#!/bin/bash
#activate HiCorr+Deeploop

name=human_Beta_cells
fq1="SRR16827076_1.downsampled.fastq.gz"
fq2="SRR16827076_2.downsampled.fastq.gz"
rdlen=50

## Step1 Mapping
hg19=/mnt/vstor/courses/gene520/Hi-C/ref/BowtieIndex/genome
lib=./lib
bowtie=/mnt/vstor/courses/gene520/ChIP-seq/software/bowtie/bowtie-1.1.2/bowtie
raw_data=./

mkdir bam

# if it's Arima kit, trim the first 5 bases!
zcat $raw_data/$fq1 | $lib/reform_fastq.for.public.tissue_python3.py 6 $rdlen | $bowtie -v 3 -m 1 --best --strata --time -p 12 --sam $hg19 - > bam/$name.aln.R1.sam &

zcat $raw_data/$fq2 |  $lib/reform_fastq.for.public.tissue_python3.py 6 $rdlen | $bowtie -v 3 -m 1 --best --strata --time -p 12 --sam $hg19 - > bam/$name.aln.R2.sam &
wait


samtools sort -@ 12 -n bam/$name.aln.R1.sam |  samtools view -S > bam/$name.aln.R1.sam.sorted &
samtools sort -@ 12 -n bam/$name.aln.R2.sam |  samtools view -S > bam/$name.aln.R2.sam.sorted &
wait

hg19=/mnt/vstor/courses/gene520/Hi-C/ref/BowtieIndex/genome.fa.fai
$lib/pairing_two_SAM_reads.pl bam/$name.aln.R1.sam.sorted bam/$name.aln.R2.sam.sorted | samtools view -bS -t $hg19 -o - - > bam/$name.bam
samtools sort bam/$name.bam | samtools view - | $lib/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $hg19 -o - - > bam/$name.sorted.nodup.bam
samtools view bam/$name.sorted.nodup.bam | cut -f2-8 | $lib/bam_to_temp_HiC.pl > bam/$name.temp


path=/mnt/vstor/courses/gene520/Hi-C/ref/hg19_GATC_GANTC
mkdir processed_frag

$lib/reads_2_cis_frag_loop.pl  $path/hg19.GATC_GANTC.frag.bed $rdlen processed_frag/$name.loop.inward processed_frag/$name.loop.outward processed_frag/$name.loop.samestrand processed_frag/summary.frag_loop.read_count $name bam/$name.temp  &
$lib/reads_2_trans_frag_loop.pl $path/hg19.GATC_GANTC.frag.bed $rdlen processed_frag/$name.loop.trans bam/$name.temp &
wait

## Step2 Count fragfilter

lib=./src
ref=/mnt/vstor/courses/gene520/Hi-C/ref/hg19_GATC_GANTC


for suffix in inward outward samestrand;do
        cat processed_frag/$name.loop.$suffix | $lib/summary_sorted_frag_loop.pl $ref/hg19.GATC_GANTC.frag.bed > processed_frag/temp.$name.loop.$suffix &
done
wait

cat processed_frag/temp.${name}.loop.samestrand | awk '{if($4>1000)print $0}' > processed_frag/frag_loop.${name}.samestrand.filter.1kb
cat processed_frag/temp.${name}.loop.samestrand | awk '{if($4>5000)print $0}' > processed_frag/frag_loop.${name}.samestrand.filter.5kb
mv processed_frag/temp.${name}.loop.samestrand processed_frag/frag_loop.${name}.samestrand
cat processed_frag/temp.${name}.loop.inward | awk '{if($4>1000)print $0}' > processed_frag/frag_loop.${name}.inward.filter
cat processed_frag/temp.${name}.loop.outward | awk '{if($4>5000)print $0}' > processed_frag/frag_loop.${name}.outward.filter
mv processed_frag/temp.${name}.loop.inward processed_frag/frag_loop.${name}.inward
mv processed_frag/temp.${name}.loop.outward processed_frag/frag_loop.${name}.outward


for suffix in trans;do
	$lib/summary_sorted_trans_frag_loop.pl processed_frag/$name.loop.trans > processed_frag/temp.$name.loop.trans
done


mv processed_frag/temp.$name.loop.trans processed_frag/frag_loop.$name.trans

$lib/merge_sorted_frag_loop.pl processed_frag/frag_loop.$name.samestrand processed_frag/frag_loop.$name.inward processed_frag/frag_loop.$name.outward > processed_frag/frag_loop.$name.cis

$lib/merge_sorted_frag_loop.pl processed_frag/frag_loop.$name.samestrand processed_frag/frag_loop.$name.inward.filter processed_frag/frag_loop.$name.outward.filter > processed_frag/frag_loop.$name.cis.filter


# Calculate the numbers
Total_reads=`cat ./bam/$name.aln.R1.sam | grep -vE ^@ | wc -l`
Uniquely_mapped=`samtools view ./bam/${name}.bam | wc -l | awk '{print $1/2}'`
Non_duplicated=`samtools view ./bam/${name}.sorted.nodup.bam | wc -l | awk '{print $1/2}'`
frag_trans=`cat processed_frag/frag_loop.${name}.trans | awk '{sum+=$3}END{print sum/2}'`
frag_cis=`cat processed_frag/frag_loop.${name}.cis | awk '{sum+=$3}END{print sum/2}'`
cisFilter=`cat processed_frag/frag_loop.${name}.cis.filter | awk '{sum+=$3}END{print sum/2}'`
frag_loop_samestrand=`cat processed_frag/frag_loop.${name}.samestrand | awk '{sum+=$3}END{print sum/2}'`
frag_loop_samestrandFilter_1kb=`cat processed_frag/frag_loop.${name}.samestrand.filter.1kb | awk '{sum+=$3}END{print sum/2}'`
frag_loop_samestrandFilter_5kb=`cat processed_frag/frag_loop.${name}.samestrand.filter.5kb | awk '{sum+=$3}END{print sum/2}'`
frag_loop_inward=`cat processed_frag/frag_loop.${name}.inward | awk '{sum+=$3}END{print sum/2}'`
frag_loop_inwardFilter=`cat processed_frag/frag_loop.${name}.inward.filter | awk '{sum+=$3}END{print sum/2}'`
frag_loop_outward=`cat processed_frag/frag_loop.${name}.outward | awk '{sum+=$3}END{print sum/2}'`
frag_loop_outwardFilter=`cat processed_frag/frag_loop.${name}.outward.filter | awk '{sum+=$3}END{print sum/2}'`
frag_cis_within_2Mb=`cat processed_frag/frag_loop.${name}.cis | awk '{if($4<=2000000){print $0}}' | awk '{sum+=$3}END{print sum/2}'`
frag_cis_100kb_2Mb=`cat processed_frag/frag_loop.${name}.cis | awk '{if($4>=100000 && $4<=2000000){print $0}}' | awk '{sum+=$3}END{print sum/2}'`
frag_cis_within_10kb=`cat processed_frag/frag_loop.${name}.cis | awk '{if($4<=10000){print $0}}' | awk '{sum+=$3}END{print sum/2}'`


echo -e "$name\tTotal_reads\t$Total_reads\tUniquely_mapped\t$Uniquely_mapped\tNon_duplicated\t$Non_duplicated\tfrag_loop_samestrand\t$frag_loop_samestrand\tfrag_loop_inward\t$frag_loop_inward\tfrag_loop_outward\t$frag_loop_outward\tfrag_cis\t$frag_cis\tfrag_trans\t$frag_trans\tfrag_loop_samestrand\t$frag_loop_samestrand\tfrag_loop_samestrand_filter_1kb\t$frag_loop_samestrandFilter_1kb\tfrag_loop_samestrand_filter_5kb\t$frag_loop_samestrandFilter_5kb\tfrag_loop_inward_filter\t$frag_loop_inwardFilter\tfrag_loop_outward_filter\t$frag_loop_outwardFilter\tfrag_cis_filterd\t$cisFilter\tfrag_cis_within_2Mb\t$frag_cis_within_2Mb\tfrag_cis_100kb_2Mb\t$frag_cis_100kb_2Mb\tfrag_cis_within_10kb\t$frag_cis_within_10kb" >> processed_frag/summary.total.read_count


rm  bam/${name}.temp processed_frag/${name}.loop.inward processed_frag/${name}.loop.outward processed_frag/${name}.loop.samestrand processed_frag/${name}.loop.trans processed_frag/frag_loop.${name}.inward.filter processed_frag/frag_loop.${name}.outward.filter processed_frag/frag_loop.${name}.samestrand.filter.1kb processed_frag/frag_loop.${name}.samestrand.filter.5kb


#echo -ne read_summary_file\\ttotal_inter\\ttotal_intra\\ttotal_samestrand\\ttotal_inward\\ttotal_outward\\tloop_samestrand\\tloop_inward\\tloop_outward\\ttotal_same_fragment\\tacross_cutting_site\\n >> summary.frag_loop.read_count


# rm $name.aln.R1.sam $name.aln.R2.sam $name.aln.R1.sam.sorted $name.aln.R2.sam.sorted  $name.temp $name.loop.inward $name.loop.outward $name.loop.samestrand $name.loop.trans frag_loop.$name.inward frag_loop.$name.outward frag_loop.$name.samestrand  frag_loop.$name.inward.filter frag_loop.$name.outward.filter

rm -rf tmp_folder.temp.$name*

