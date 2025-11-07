#!/usr/bin/perl

use strict;

my $usage = "Usage:./peak_filter.pl <cutoff total count> <cutoff total p_val> <cutofff single count> <cutoff single p_val> <file>\n";

my ($c_total_cut, $p_total_cut, $c_single_cut, $p_single_cut, $file) = @ARGV;
if(not defined $p_single_cut){
	die($usage);
}

if(not defined $file){
	$file = "-";
}

open(IN, $file);
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $c_total, $l_total, $p_total, $id_single_str, $c_single_str, $l_single_str, $p_single_str) = split "\t", $line;
	if($c_total > $c_total_cut && $p_total < $p_total_cut){
		print $line."\n";
		next;
	}
	
	my $flag = 0;
	my @id_single = split ",", $id_single_str;
	my @c_single = split ",", $c_single_str;
	my @l_single = split ",", $l_single_str;
	my @p_single = split ",", $p_single_str;
	for(my $i = 0; $i <= $#id_single; $i ++){
		if($c_single[$i] > $c_single_cut && $p_single[$i] < $p_single_cut){
			$flag =1;
		}
	}
	if($flag){
		print $line."\n";
	}
}
 
exit;
