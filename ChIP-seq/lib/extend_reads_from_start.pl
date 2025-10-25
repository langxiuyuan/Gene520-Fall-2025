#!/usr/bin/perl

use strict;
my $usage =	"Usage:./extend_reads_from_start.pl <bed> <length> <genome>\n".
		"\tThis program extend reads in <bed> file to <length>. Recommend to use 0-system.\n".
		"\t<genome> is optional to limit extension to be within the boundaries of genome. For example, it could be hg18 for human genome.\n";

my ($bed, $len, $genome) = @ARGV;
if(not defined $len){
	die($usage);
}

my $jin = "/mnt/NFS/homeGene/JinLab/fxj45";


my $refsize;
if($genome eq "hg19"){
	open(IN,"/home/xww/file_code/ChIP-seq/hg19.chrom.sizes") || die("Error: Cannot open hg19 chrom.sizes\n");
	while(my $line = <IN>){
                chomp $line;
                my ($chr, $size) = split "\t", $line;
                $refsize->{$chr} = $size;
        }
        close(IN);
}elsif($genome eq "mm10"){
	open(IN,"/mnt/vstor/courses/gene520/ChIP-seq/Ref/mm10_bowtie_index/mm10.chrom.sizes") || die("Error: Cannot open mm10 chrom.sizes\n");
        while(my $line = <IN>){
                chomp $line;
                my ($chr, $size) = split "\t", $line;
                $refsize->{$chr} = $size;
        }
        close(IN);	
}elsif(defined $genome && -e "$jin/GenebankDB/$genome/chrom.sizes"){
	open(IN, "$jin/GenebankDB/$genome/chrom.sizes") || die("Error: Cannot open file $jin/GenebankDB/$genome/chrom.sizes\n");
	while(my $line = <IN>){
		chomp $line;
		my ($chr, $size) = split "\t", $line;
		$refsize->{$chr} = $size;
	}
	close(IN);
}

open(IN,$bed) || die("Error: Cannot open file $bed!\n");
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $score, $strand, @rest) = split "\t", $line;
	
	if($beg < 0 || $end > $refsize->{$chr}){
		next;
	}

	if($strand eq "-"){
		$beg = ($end-$len > 0)?($end-$len):0;
	}else{
		$end = ($beg+$len < $refsize->{$chr})?($beg+$len):$refsize->{$chr};
	}
	print join("\t",$chr, $beg, $end, $id, $score, $strand, @rest )."\n";
}
close(IN);
exit;
