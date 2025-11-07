#!/usr/bin/perl

use strict;

my $usage =	"Usage: resize_peak.pl <bed file> <bandwidth>\n".
		"\tRead bed files for peaks. Resize each peaks with the same center ranged\n".
		"\t[center-<bandwidth>, center+<bandwidth>). Generate new bed file format.\n"; 

my ($bed, $bandwidth) = @ARGV;

if(not defined $bandwidth){
	die($usage);
}

open(IN, $bed) || die("Error: Cannot open file $bed!\n");
while(my $line = <IN>){
	if($line =~ /^#/){
		print $line;
		next;
	}
	chomp $line;
	my ($chr, $start, $end, @rest) = split("\t", $line);
	my $newstart = int(($start + $end)/2 - $bandwidth);
        my $newend = int(($start + $end)/2 + $bandwidth);
	print join("\t", $chr, $newstart, $newend, @rest)."\n";
}
exit;
