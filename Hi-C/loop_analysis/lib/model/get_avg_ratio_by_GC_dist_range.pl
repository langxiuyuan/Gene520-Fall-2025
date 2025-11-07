#!/usr/bin/perl

use strict;
my ($regress, $frag_bed, $GC_group_file, $frag_stat_file, $min_map, $min_dist, $max_dist) = @ARGV;
if(not defined $min_map){
	die("Usage:./get_avg_ratio_by_GC_dist_range.pl <frag_loop_data> <frag_bed> <frag_GC_group> <frag_stat> <min_map> <min_dist> <max_dist>\n");
}

my $frag_loc;
open(IN, $frag_bed);
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $id) = split "\t", $line;
        $frag_loc->{$id} = join(":", $beg, $end);
}
close(IN);

##################### determine the GC group for fragments #################
my $GC_range;
open(IN, $GC_group_file);
while(my $line = <IN>){
        chomp $line;
        my ($id, $min, $max) = split "\t", $line;
        $GC_range->{$id} = "$min:$max";
}
close(IN);

my $frag_gc_group;
my $frag_map;
open(IN, $frag_stat_file);
while(my $line=<IN>){
	chomp $line;
	my ($id, $gc, $map) = split "\t", $line;
	$frag_gc_group->{$id} = get_id($gc, $GC_range);
	$frag_map->{$id} = $map;
}
close(IN);


################## Calculate group averages #######################################
my $g_sum_lambda;
my $g_sum_reads;
my $g_count;
open(IN, $regress);
while(my $line = <IN>){
	chomp $line;
	my ($frag1, $frag2, $count, $lambda) = split "\t", $line;
	
	if($frag_map->{$frag1} < $min_map || $frag_map->{$frag2} < $min_map){
		next;
	}	

	my ($beg1, $end1) = split ":", $frag_loc->{$frag1};
	my ($beg2, $end2) = split ":", $frag_loc->{$frag2};
	my $dist = ($beg1 < $beg2)?($beg2 - $end1 - 1):($beg1 - $end2 -1);
	if($dist < $min_dist || $dist >= $max_dist){
		next;
	}
	
	my $g1 = $frag_gc_group->{$frag1};
	my $g2 = $frag_gc_group->{$frag2};
	if(not defined $g_sum_lambda->{$g1}->{$g2}){
		$g_sum_lambda->{$g1}->{$g2} = 0;
	}
	if(not defined $g_count->{$g1}->{$g2}){
                $g_count->{$g1}->{$g2} = 0;
        }
	if(not defined $g_sum_reads->{$g1}->{$g2}){
                $g_sum_reads->{$g1}->{$g2} = 0;
        }
	$g_count->{$g1}->{$g2} ++;
	$g_sum_lambda->{$g1}->{$g2} += $lambda;
	$g_sum_reads->{$g1}->{$g2} += $count;
}
close(IN);

foreach my $g1 (sort {$a<=>$b} keys %{$g_sum_reads}){
	foreach my $g2 (sort {$a<=>$b} keys %{$g_sum_reads->{$g1}}){
		my $count = $g_count->{$g1}->{$g2};
		my $sum_lambda = $g_sum_lambda->{$g1}->{$g2};
		my $sum_reads = $g_sum_reads->{$g1}->{$g2};
		my $ratio = $sum_reads / $sum_lambda;
		print join("\t", $g1, $g2, $count, $ratio)."\n";
	}
}

exit;


##############################################################
sub get_id{
        my ($val, $range) = @_;
        foreach my $id (keys %{$range}){
                my ($min, $max) = split ":", $range->{$id};
                if($val > $min && $val <= $max){
                        return $id;
                }
        }
        die("Error: did not find a group\n");
}

