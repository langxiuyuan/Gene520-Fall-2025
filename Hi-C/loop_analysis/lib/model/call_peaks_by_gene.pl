#!/usr/bin/perl

use strict;

my $usage = "Usage:./call_peaks_by_gene.pl <datafile> <p_seed> <p_ext> <maxgap>\n";

my ($file, $p_seed, $p_ext, $maxgap) = @ARGV;
if(not defined $p_ext){
	die($usage);
}

if(not defined $maxgap){
	$maxgap = 1;
}

my $ind = 1;
my $curr_gene = "";
my $curr_chr = "";
#my $curr_name = "";
my $have_seed = 0;
my ($peak_beg, $peak_end) = (0,0);
my @seed_fid = ();
my @seed_count= ();
my @seed_pval = ();
my @seed_lambda = ();

my @gap_fid = ();
my @gap_count = ();
my @gap_pval = ();
my @gap_lambda = ();

open(IN, $file);
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $fid, $gene, $val, $rand, $p) = split "\t", $line;

	if($gene ne $curr_gene || ($beg - $peak_end) > $maxgap || $chr ne $curr_chr){
		if($have_seed){
			my $ID = $curr_chr."_Int_".$ind;
			print join("\t", $curr_chr, $peak_beg, $peak_end, $ID, $curr_gene, sum_array(\@seed_count), sum_array(\@seed_lambda), join(",", @seed_fid), join(",", @seed_count), join(",", @seed_lambda), join(",", @seed_pval))."\n";
			$have_seed = 0;
			$ind ++;
		}
		($curr_chr, $curr_gene, $peak_beg, $peak_end) = ($chr, $gene, 0, 0);
		@seed_fid = (); @seed_count= (); @seed_pval = (); @seed_lambda = ();
		@gap_fid = (); @gap_count= (); @gap_pval = (); @gap_lambda = ();
	}

	if($p < $p_ext){
		if(!$peak_beg){
			$peak_beg = $beg;
		}
		$peak_end = $end;
		if(@gap_fid){
			push @seed_fid, @gap_fid;	@gap_fid = ();  
			push @seed_count, @gap_count;	@gap_count = ();
			push @seed_pval, @gap_pval;	@gap_pval = (); 
			push @seed_lambda, @gap_lambda;	@gap_lambda = ();
		}
		push @seed_fid, $fid;
		push @seed_count, $val;
		push @seed_pval, $p;
		push @seed_lambda, $rand;
	}elsif(($beg - $peak_end) <= $maxgap){
		push @gap_fid, $fid;
		push @gap_count, $val;
		push @gap_pval, $p;
		push @gap_lambda, $rand;
	}else{
		@gap_fid = ();
		@gap_count = ();
		@gap_pval = ();
		@gap_lambda = ();
	}

	if($p < $p_seed){
		$have_seed = 1;
	}
}

if($have_seed){
	my $ID = $curr_chr."_Int_".$ind;
	print join("\t", $curr_chr, $peak_beg, $peak_end, $ID, $curr_gene, sum_array(\@seed_count), sum_array(\@seed_lambda), join(",", @seed_fid), join(",", @seed_count), join(",", @seed_lambda), join(",", @seed_pval))."\n";
	$ind ++;
}

exit;

#############################################################
sub sum_array{
	my ($arrayref) = @_;
	my $sum = 0;
	foreach my $x (@$arrayref){
		$sum += $x;
	}
	return $sum;
}
