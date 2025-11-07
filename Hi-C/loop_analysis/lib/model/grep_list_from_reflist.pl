#!/usr/bin/perl

my ($list, $ind_list, $reflist, $ind_ref, $gcfile) = @ARGV;

if(not defined $ind_ref) {
	die(	"Usage: ./grep_list_from_reflist.pl <listfile> <list_index> <reflist> <ref_index> <gabbage file>\n".
		"\tThis program go through the ID (designated by <list_index>) of every line from <listfile>\n".
		"\tand print the whole line if the ID is in the IDs of <reflist> (designated by <ref_index>).\n".
		"\tThe rest lines from <listfile> will be print into <gabbage file>. <gabbage file> is optional.\n".
		"\tBoth <listfile> and <reflist> should be delimited by TAB.\n"
	);
}

$ind_list--;
$ind_ref--;
open(IN, $reflist) || die("Error: Cannot open file $reflist.\n");
my $ref_id;
while(my $line = <IN>){
	if ($line =~ /^#/){next;}
	chomp $line;
	my @all = split("\t", $line);
	${$ref_id->{$all[$ind_ref]}} = 1;
}
close(IN);

if($gcfile){
	open(OUT, ">$gcfile") || die("Error: Cannot open file $gcfile for writing.\n");
}

open(IN, $list);
while(my $line = <IN>){
	if ($line =~ /^#/){next;}
	chomp $line;
	my @all = split("\t", $line);
	if(${$ref_id->{$all[$ind_list]}}){
		print "$line\n";
	}elsif($gcfile){
		print OUT "$line\n";
	}else{
	}
}
close(IN);

if($gcfile){
	close(OUT);
}

exit;
