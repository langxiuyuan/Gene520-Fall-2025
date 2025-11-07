#!/usr/bin/perl
use strict;
#use POSIX;
my $usage = "Usage: extract.reads.pl <loop> <percent> \n";
my ($loop, $percent) = @ARGV;
if(not defined $percent){
        die($usage);
}
open(IN, $loop);
my $frag_pair;
while(my $line= <IN>){
        chomp $line;
	my $random_value=0;
        my ($frag1,$frag2,$reads,$dist)= split "\t", $line;
	my @str1 = split /_/, $frag1;
        my $ss1=@str1[1];
        my @str2 = split /_/, $frag2;
        my $ss2=@str2[1];
        if($ss1 lt $ss2){
	if($reads ne 0){
		if(!$frag_pair->{$frag1}->{$frag2}){
			for( my $i=1; $i<=$reads; $i++){
				my $int=int(rand(100));
				if($int <= $percent){
					$random_value+=1;
				}
			}
			$frag_pair->{$frag1}->{$frag2}=$random_value;
#			$frag_pair->{$frag2}->{$frag1}=$random_value;
		}else{
			$random_value=$frag_pair->{$frag1}->{$frag2};
		}
		#my $new_reads=ceil($reads*$percent);
		print join("\t",$frag1,$frag2,$random_value,$dist)."\n";
#		print join("\t",$frag2,$frag1,$random_value,$dist)."\n";
	}else{
		print $line."\n";
	}
	}

}
close(IN);
exit;
