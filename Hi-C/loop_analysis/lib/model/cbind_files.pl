#!/usr/bin/perl

use strict;

my $option;
if ($ARGV[0] eq "-f"){
	$option = shift @ARGV;
}

my ($delim, @file) = @ARGV;

if(!@file){
	die(	"Usage: cbind_files.pl <option> <delim> <file 1> <file 2>...\n".
		"\t<delim> should be \\\\t if you want TAB to be the delimit character.\n".
		"Option:\n\t-f\tForce cbind ignoring number of lines.\n"
	);
}

#print $delim;
#<stdin>;

$delim =~ s/\\t/\t/g;


my @fhandle = ();
my @n = ();
for(my $i = 0; $i <= $#file; $i++){
	open($fhandle[$i], $file[$i]) || die("Cannot open file ".$file[$i]."!\n");
	my $line = `wc -l $file[$i]`;
	($n[$i]) = ($line =~ /([0-9]+)\W/);
}

my $nline = $n[0];

for(my $i = 1; $i <= $#n; $i++){
	if($nline != $n[$i]){
		if(!$option){
			die("Error: The line numbers of these files are different!\n");
		}
		if($n[$i] > $nline) {
			$nline = $n[$i];
		}
	}
}

for(my $i = 0; $i < $nline; $i++){
	my @lines = ();
	for(my $j =0; $j<=$#fhandle; $j++){
		my $fh = $fhandle[$j];
		$lines[$j] = <$fh>;
		chomp $lines[$j];
	}
	print join($delim, @lines)."\n";
}

for(my $i = 0; $i <= $#file; $i++){
	close($fhandle[$i]) || die("Cannot close file ".$file[$i]."!\n");
}
exit;
