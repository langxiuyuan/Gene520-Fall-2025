#!/usr/bin/perl

use strict;

my ($low_lim, $high_lim) = @ARGV;
open(IN, "-") || die("Error: Cannot open STDIN!\n");
while(my $line = <IN>){
	chomp $line;
	my ($obs, $expt) = split "\t", $line;
	if ($expt>$low_lim && $expt<$high_lim){
		print $line."\n";
	}
}
close(IN);
exit;
