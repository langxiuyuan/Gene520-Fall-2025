#!/usr/bin/perl

use strict;

my ($col, $file) = @ARGV;
if(not defined $file){
	$file = "-";
} 

my $sum = 0;
open(IN, $file) || die("Error: Cannot open $file!\n");
while(my $line = <IN>){
	chomp $line;
	my @array = split "\t", $line;
	$sum += $array[$col - 1];
}
close(IN);
print $sum."\n";
exit;
