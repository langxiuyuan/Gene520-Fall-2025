#!/usr/bin/perl

use strict;

my $usage = "Usage:./batch_anchor.pl <frag_bed> <loop_list> <promoter_map>\n";

my ($frag_bed, $loop_list, $map_file) = @ARGV;

if(not defined $map_file){
        die($usage);
}

################## Read fragment locations ##################
my $frag_loc;
open(IN, $frag_bed) || die("Error: Cannot open file $frag_bed!\n");
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $frag_loc->{$id} = join("\t", $chr, $beg, $end);
}
close(IN);

##################### Read fragment map #####################
my $map_frag;
my $map_gene;
open(IN, $map_file) || die("Error: Cannot open file $map_file!\n");
while(my $line = <IN>){
        chomp $line;
        my ($fid, $gid) = split "\t", $line;
        $map_frag->{$fid} = $gid;
	push @{$map_gene->{$gid}}, $fid;
}
close(IN);

######################## Bed fragment ########################
my $loop_bed;
my $random_bed;
open(IN, $loop_list) || die("Error: Cannot open file $loop_list!\n");
while(my $line = <IN>){
        chomp $line;
        my ($fid1, $fid2, $val, $rand) = split "\t", $line;
	my $gid;
	$gid = $map_frag->{$fid1};
	if(not find($fid2, @{$map_gene->{$gid}})){
		if(not defined $loop_bed->{$gid}->{$fid2}){
			$loop_bed->{$gid}->{$fid2} = $val;
		}else{
			$loop_bed->{$gid}->{$fid2} += $val;
		}
		if(not defined $random_bed->{$gid}->{$fid2}){
			$random_bed->{$gid}->{$fid2} = $rand;
		}else{
			$random_bed->{$gid}->{$fid2} += $rand;
		}
	}
}
close(IN);

####################### Output files ######################
foreach my $gid (sort {($a=~/.+_([0-9]+)$/)[0] <=> ($b=~/.+_([0-9]+)/)[0]} keys %$loop_bed){
#	my $name = $gene_names->{$gid};
	
        foreach my $fid (sort {($a=~/.+_([0-9]+)$/)[0] <=> ($b=~/.+_([0-9]+)/)[0]} keys %{$random_bed->{$gid}}){
                my $rand = $random_bed->{$gid}->{$fid};
		my $val = 0;
		if(defined $loop_bed->{$gid}->{$fid}){
			$val = $loop_bed->{$gid}->{$fid};
		}
		print join("\t", $frag_loc->{$fid}, $fid, $gid, $val, $rand)."\n";
        }
}

exit;

#####################################################################
sub find{
        my ($x, @array) = @_;
        foreach my $a (@array){
                if($x eq $a){
                        return 1;
                }
        }
        return 0;
}

