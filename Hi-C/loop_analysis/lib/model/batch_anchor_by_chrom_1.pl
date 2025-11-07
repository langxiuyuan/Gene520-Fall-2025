#!/usr/bin/perl

use strict;

my $usage = "Usage:./batch_anchor_by_chrom.pl <frag_bed> <loop_list> <promoter_map>\n";

my ($frag_bed, $loop_list, $map_file) = @ARGV;

if(not defined $map_file){
        die($usage);
}

my $chr_ref;
################## Read fragment chrom ##################
my $frag_chrom;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $frag_chrom->{$id} = $chr;
	$chr_ref->{$chr} = 1;
}
close(IN);

my $dir = "temp.by.chrom";
`mkdir $dir`;

split_by_chr($frag_bed, $frag_chrom, $dir, $chr_ref, 4);
split_by_chr($map_file, $frag_chrom, $dir, $chr_ref, 1);
split_by_chr($loop_list, $frag_chrom, $dir, $chr_ref, 1);

foreach my $chr (keys %$chr_ref){
	`./batch_anchor.pl $dir/$frag_bed.$chr $dir/$loop_list.$chr $dir/$map_file.$chr > $dir/anchor.loop_frag.bed.$chr`;
	open(IN, "get_frag_pval.r");
	open(OUT, ">$dir/get_frag_pval.$chr.r");
	while(my $line = <IN>){
		$line =~ s/FILE/$dir\/anchor.loop_frag.bed.$chr/g;
		print OUT $line;
	}
	close(OUT);
	close(IN);
	`R --quiet --vanilla < $dir/get_frag_pval.$chr.r`;

	`./call_peaks_by_gene.pl $dir/anchor.loop_frag.bed.$chr.p_val 0.05 0.1 1000 > $dir/anchor.loop_peak.bed.$chr`;

	`cat $dir/anchor.loop_peak.bed.$chr | cut -f4,6,7 > $dir/temp.$chr.list`;
        open(IN, "get_peak_pval.r");
        open(OUT, ">$dir/get_peak_pval.$chr.r");
        while(my $line = <IN>){
                $line =~ s/FILE/$dir\/temp.$chr.list/g;
                print OUT $line;
        }
        close(OUT);
        close(IN);
        `R --quiet --vanilla < $dir/get_peak_pval.$chr.r`;
	`cp $dir/anchor.loop_peak.bed.$chr $dir/anchor.loop_peak.bed.$chr.p_val`;
	`insert_another_column.pl $dir/anchor.loop_peak.bed.$chr.p_val 4 $dir/temp.$chr.list.p_val 1 4 8`;
	`rm $dir/temp.$chr.list* $dir/get_peak_pval.$chr.r`;
}

exit;


##########################################################################
sub split_by_chr{
	my ($file, $frag_chrom, $dir, $chr_ref, $col) = @_;
	my $fh_ref;
	foreach my $chr (keys %$chr_ref){
		open($fh_ref->{$chr}, ">$dir/$file.$chr");
	}
	
	open(IN, $file);
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
