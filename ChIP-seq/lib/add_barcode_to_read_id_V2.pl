#!/usr/bin/perl

use strict;

my ($barcode,$fq,$length) = @ARGV;

if(not defined $length){
	die("Usage: ./add_barcode_to_read_id.pl <barcode_file.fastq> <reads_file.fastq> <length_of_barcode>\n If you don't have another barcode fastq file, but only want to remove space in reads name, use:\n\t./add_barcode_to_read_id.pl none <reads_file.fastq> 0\n");
}
if ($barcode == 'none'){
	open(IN, $fq) || die("Error: Cannot open file $fq.\n");
	while(my $line1 = <IN>){
	        chomp $line1;
        	my ($id, $tag) = split /\s/, $line1;
                print $id."\n";
        	my $line2 = <IN>; print $line2;
        	my $line3 = <IN>; print $line3;
        	my $line4 = <IN>; print $line4; 
          }
	close(IN);
}else{
	open(BAR,$barcode) ||die("Error: Cannot open file $barcode.\n");
	open(IN, $fq) || die("Error: Cannot open file $fq.\n");
	my $bc= <BAR>;
	while(my $line1 = <IN>){
		chomp $line1;
		my ($id, $tag) = split /\s/, $line1;
		$bc= <BAR>;
		$bc = substr $bc,0,$length;
		print join(":", $id, $bc)."\n";
		my $line2 = <IN>; print $line2;
		my $line3 = <IN>; print $line3;
		my $line4 = <IN>; print $line4;
		my $i=0;
		while($i<3){
			$bc=<BAR>;
			$i=$i+1;
		}
	}	
	close(IN);
	close(BAR);
}
exit;
