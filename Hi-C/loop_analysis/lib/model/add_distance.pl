#!/usr/bin/perl

use strict;
my $usage = 	"./add_distance.pl <anchor_bed> <anchor_pairs>\n".
		"\tTake pairs of anchorid as input, add the distance to the end of the line.\n";
my ($anchor_bed, $anchor_pairs) = @ARGV;
if(not defined $anchor_bed){
	die($usage);
}
if(not defined $anchor_pairs){
	$anchor_pairs = "-";
}

my $anchor_ref;
open(IN, $anchor_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
	$anchor_ref->{$id} = join("\t", $chr, $beg, $end);
}
close(IN);

open(IN, $anchor_pairs);
while(my $line = <IN>){
        chomp $line;
        my ($id1, $id2) = split "\t", $line;
	my ($chr1, $beg1, $end1) = split "\t", $anchor_ref->{$id1};
	my ($chr2, $beg2, $end2) = split "\t", $anchor_ref->{$id2};
	if($chr1 ne $chr2){
		print join("\t", $id1, $id2, "INF")."\n";
	}else{
		my $dist = ($beg1 < $beg2)? ($beg2-$end1-1):($beg1-$end2-1);
		print join("\t", $id1, $id2, $dist)."\n";
	}
}
exit;
