#!/usr/bin/perl

use strict;
my $usage = "Usage:./bowtie_fastq.pl <genome> <cpu> <fastq>\n";
# my $bowtie = "/mnt/rds/genetics01/JinLab/xww/software/bowtie-1.1.2/bowtie"; 
 my $bowtie = "/mnt/vstor/courses/gene520/ChIP-seq/software/bowtie/bowtie-1.1.2/bowtie";

my ($genome, $cpu, $fq) = @ARGV;
if(not defined $fq){
        die($usage);
}

my $bowtie_index;
if($genome eq "hg18"){
        $bowtie_index="/mnt/rstor/genetics/JinLab/fxj45/Illumina_iGenomes/Homo_sapiens/UCSC/hg18/Sequence/BowtieIndex/genome";
}elsif($genome eq "mm9"){
        $bowtie_index = "/mnt/jinstore/JinLab02/fxj45/Illumina_iGenomes/Mus_musculus/UCSC/mm9/Sequence/BowtieIndex/genome";
}elsif($genome eq "hg19"){
	$bowtie_index ="/home/xww/file_code/ref/hg19/genome";
}elsif($genome eq "mm10"){
	$bowtie_index ="/home/xww/file_code/ref/mm10/mm10";
}else{
        die("Error: Genome is not right!\n$usage");
}

my $len = `head -2 $fq | tail -1 | wc -m`;
$len --;
my $trim3 = 0;
if($len > 36){
        $trim3 = $len - 36;
}
my $v = 2;
if($len <= 25){
        $v --;
}

my $sam = $fq;
$sam =~ s/fastq$/sam/;

if($trim3 > 0){
        `$bowtie -v $v -m 1 --best --strata --trim3 $trim3 --time -p $cpu --sam $bowtie_index $fq $sam`;
}else{
        `$bowtie -v $v -m 1 --best --strata --time -p $cpu --sam $bowtie_index $fq $sam`;
}

exit;
