#!/usr/bin/perl

use strict;

my ($fq, $length) = @ARGV;

if( not defined $length){
	die("Usage: ./trim_fastq_reads.pl <reads_file.fastq> <desired_read_length>\n");
}

open(IN, $fq) || die("Error: Cannot open file $fq.\n");

while(my $line1 = <IN>){
	print $line1;
	my $line2 = <IN>; 
	my $reads=substr $line2,0,$length;	#trim sequence reads to desired length
	print $reads."\n";
	my $line3 = <IN>; print $line3;
	my $line4 = <IN>; 
	my $qscore=substr $line4,0,$length;	#trim quality score to desired length
	print $qscore."\n";	
}

close(IN);
exit;
