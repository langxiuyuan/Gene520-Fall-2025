#!/usr/bin/perl

use strict;
my $usage = 	"./generate_exon_bed.pl <geneid_to_exonid> <exon_locations>\n".
		"\tThis program generate a bed file list all exons for any gene\n";
		"\t<gene_info> contains GeneID, GeneName, and Strand in the first three columns.\n";

my ($map_file, $exon_file) = @ARGV;
if(not defined $exon_file){
	die($usage);
}

my $exon_chr;
my $exon_beg;
my $exon_end;
open(IN, $exon_file);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $eid) = split "\t", $line;
	$exon_chr->{$eid} = $chr;
        $exon_beg->{$eid} = $beg;
	$exon_end->{$eid} = $end;
}
close(IN);

my $map;
open(IN, $map_file);
while(my $line = <IN>){
        chomp $line;
        my ($gid, $eid, @rest) = split "\t", $line;
	print join("\t", $exon_chr->{$eid}, $exon_beg->{$eid}, $exon_end->{$eid}, $gid, @rest)."\n";
}
close(IN);

exit;

