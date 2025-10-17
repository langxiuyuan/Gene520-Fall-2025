#!/usr/bin/perl

use strict;

my $usage = 	"Usage:./sorted_bed_2_wig_no_strand.pl <option> <bed>\n".
		"\tThis program read a list of reads from <bed> file and output wig file format without loss of any information.\n".
		"\tThe <bed> file must using 1-system and sorted using sort -k1,1 -k2,2n.\n".
		"\t<option> -c will add the 5th column as count. Support pipe now.\n";

my $option;
if($ARGV[0] =~ /^-/){
        $option = shift @ARGV;
}
$option =~ s/-//;

my ($bed) = @ARGV;
if(not defined $bed){
	$bed = "-";
}

my @locs = ();
my @changes = ();
my $curr_total = 0;

my $prev_chr = "";
my $reg_chr;

open(IN, $bed) || die("Error: Cannot open file $bed!\n$usage");
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $id, $score, $strand) = split "\t", $line;

	if( ($option !~ /c/) || (not defined $score)){
                $score = 1;
        }

        if($chr ne $prev_chr){
                if(defined $reg_chr->{$chr}){
                        die("Error: $bed should be sorted by chrom!\n$usage");
                }

		#dump all
		if($#locs >= 0){
			$curr_total = output_till($prev_chr, $locs[$#locs], \@locs, \@changes, $curr_total);
		}
		#initial new data
                $reg_chr->{$chr} = 1;
		insert(\@locs, $beg, \@changes, $score);
		insert(\@locs, $end + 1, \@changes, 0 - $score);
                $prev_chr = $chr;

        }elsif($beg < $locs[0]){
                die("Error: $bed should be sorted by beg!\n$usage");
        }else{
		if($#locs >= 0){
			$curr_total = output_till($prev_chr, $beg - 1, \@locs, \@changes, $curr_total);
		}
		insert(\@locs, $beg, \@changes, $score);
		insert(\@locs, $end + 1, \@changes, 0 - $score);
	}
}

if($#locs >= 0){
	$curr_total = output_till($prev_chr, $locs[$#locs], \@locs, \@changes, $curr_total);
}

close(IN);

exit;

##############################################################
sub insert{
	my ($locref, $location, $numref, $number) = @_;
	my @temp_loc = ();
	my @temp_num = ();
	while((defined $$locref[0]) && $$locref[0] < $location){
		push @temp_loc, (shift @$locref);
		push @temp_num, (shift @$numref);
	}
	if((not defined $$locref[0]) || $$locref[0] > $location){
		push @temp_loc, $location;
		push @temp_num, $number;
	}elsif($$locref[0] == $location){
		$$numref[0] += $number;
	}else{
		die("Error: Something is wrong!\n");
	}
	unshift @$locref, @temp_loc;
	unshift @$numref, @temp_num;
	return;
}

sub output_till{
	my ($chr, $location, $locref, $numref, $total) = @_;
	
	if((not defined $$locref[0]) || $$locref[0] > $location){
		return $total;
	}

	my $prev = shift @$locref;
	$total += shift @$numref;
	while((defined $$locref[0]) && $$locref[0] <= $location){
		my $loc = shift @$locref;
		if($$numref[0] != 0){
			print join("\t", $chr, $prev, $loc - 1, $total)."\n";
			$total += shift @$numref;
			$prev = $loc;
		}
	}
	if($total){
		print join("\t", $chr, $prev, $location, $total)."\n";
	}
	return $total;
}
