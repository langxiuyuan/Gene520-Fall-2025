#!/usr/bin/perl
use strict;
my ($file, $percent) = @ARGV;
open(INFILE, $file) or die "Can't open file";
while(my $line = <INFILE>){
	chomp $line;
	my($frag1,$frag2,$reads)=split "\t", $line;
	my @str1 = split /\_/, $frag1;
        my $ss1=@str1[1];
	my @str2 = split /\_/, $frag2;
        my $ss2=@str2[1];
	if($ss1 lt $ss2){
		my $random_value=0;
		for( my $i=1; $i<=$reads; $i++){
                	my $int=int(rand(100));
                	if($int <= $percent){
                        	$random_value+=1;
                	}
        	}
		if($random_value > 0){
			print join("\t",$frag1,$frag2,$random_value)."\n";
			print join("\t",$frag2,$frag1,$random_value)."\n";
		}
	}
}
close (INFILE);
exit;

