#!/usr/bin/perl

use strict;

my $usage = 	"Usage:./sorted_bed_merge_redundant_lines_V2.pl <option> <bed>\n".
		"\tThis program read sorted bed file and merged redundant locations into the same line and\n".
		"\toutput the number of occurence for each location in the 5th col. Strand matters for each line.\n".
		"\tWhen <option> is \"-c\", this program will add up all 5th column for all the bed lines denoting the same genomic location.\n".
		"\tVersion 2 support pipe. Do not require strand column to be sorted. But it does not check errors.\n";

my $option;
if($ARGV[0] =~ /^-/){
	$option = shift @ARGV;
}
$option =~ s/-//;

my ($bed) = @ARGV;
if(not defined $bed){
	$bed = "-";
}

open(IN, $bed) || die("Error: Cannot open file $bed!\n$usage");

my $count_ref;
my $prev_reg = "";
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $score, $strand) = split "\t", $line;
	if(! ($option =~ /c/)){
		$score = 1;
	}
	my $reg="$chr\t$beg\t$end";
	if($reg ne $prev_reg){
		if($prev_reg){
			foreach my $str (sort keys %$count_ref){
				print join("\t", $prev_reg, ".", $count_ref->{$str}, $str)."\n";
				delete $count_ref->{$str};
			}
		}
		$prev_reg = $reg;
		$count_ref->{$strand} = 0;
	}
	$count_ref->{$strand} += $score;
}
close(IN);

if($prev_reg){
	foreach my $str (sort keys %$count_ref){
		print join("\t", $prev_reg, ".", $count_ref->{$str}, $str)."\n";
		delete $count_ref->{$str};
	}
}

exit;
