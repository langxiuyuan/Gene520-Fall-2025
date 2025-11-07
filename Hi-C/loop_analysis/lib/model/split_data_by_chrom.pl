#!/usr/bin/perl

use strict;

my $usage = "Usage:./split_data_by_chrom.pl <anchor_bed> <loop_list>\n";

my ($anchor_bed, $loop_list) = @ARGV;

if(not defined $loop_list){
        die($usage);
}

my $chr_ref;
my $anchor_chrom;
open(IN, $anchor_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $anchor_chrom->{$id} = $chr;
	$chr_ref->{$chr} = 1;
}
close(IN);

my $dir = "temp.by.chrom";
`mkdir $dir`;

split_by_chr($loop_list, $anchor_chrom, $dir, $chr_ref, 1);

exit;


##########################################################################
sub split_by_chr{
	my ($file, $frag_chrom, $dir, $chr_ref, $col) = @_;
	my $fh_ref;
	foreach my $chr (keys %$chr_ref){
		open($fh_ref->{$chr}, ">$dir/$file.$chr");
	}
	
	open(IN, $file);
	my $title = <IN>;
	foreach my $chr (keys %$chr_ref){
		my $fh = $fh_ref->{$chr};
		print $fh $title;
        }    

	while(my $line = <IN>){
		chomp $line;
		my @vals = split "\t", $line;
		my $fid = $vals[$col - 1];
		my $chr = $frag_chrom->{$fid};
		my $fh = $fh_ref->{$chr};
		print $fh $line."\n";
	}
	close(IN);
	
        foreach my $chr (keys %$chr_ref){
                close $fh_ref->{$chr};
        }
	return;       
}
