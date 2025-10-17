#!/usr/bin/perl
use strict;
my $usage = 	"Usage:./UCSC_2_normal.pl <bed>".
		"\tThis program convert bed file using UCSC 0-system into normal 1-system.\n".
		"\tSupport pipe now.\n";
my ($bed) = @ARGV;
if(not defined $bed){
	$bed = "-";
}

open(IN, $bed) || die("Error: Cannot open file $bed!\n$usage");
while(my $line = <IN>){
	chomp $line;
	my @a = split "\t", $line;
	$a[1] += 1;
	print join("\t", @a)."\n";
}
close(IN);
exit;
