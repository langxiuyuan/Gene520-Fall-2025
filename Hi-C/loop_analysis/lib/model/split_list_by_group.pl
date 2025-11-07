#!/usr/bin/perl

use strict;

my ($group_file, $list_file) = @ARGV;

open(IN, $group_file) || die("Error: Cannot open $group_file!\n");
while(my $line = <IN>){
	chomp $line;
	my ($group, $lambda, $fraction) = split "\t", $line;
	my $low_lim = $lambda * (1 - $fraction);
	my $high_lim = $lambda * (1 + $fraction);
	#`cat $list_file | cut -f3-4 | perl -ne 'chomp;split;if(\$_[1] > $low_lim && \$_[1] < $high_lim){print;print \"\\n\"};' > data_list.group.$group &`;
	`cat $list_file | cut -f3-4 | ./reform.pl $low_lim $high_lim > data_list.group.$group`;
	#print "Is speed ok now?[enter to run more]";
	#<stdin>;
}
close(IN);
exit;
