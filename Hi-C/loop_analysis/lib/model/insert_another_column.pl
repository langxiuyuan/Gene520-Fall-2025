#!/usr/bin/perl

use strict;

my ($list, $id_list, $reflist, $id_ref, $ind_val, $col) = @ARGV;

my $usage = 	"Usage: ./insert_another_column.pl <listfile> <ID_list> <reflist> <ID_ref> <data index> <col>\n".
                "\tThis program go through the ID (designated by <ID_list>) of every line from <listfile>\n".
                "\tand insert a column of data (designated by <data index>) from <reflist> with the same ID\n".
                "\t(designated by <ID_ref>) to the <col> column of <listfile>.\n".
                "\tBoth <listfile> and <reflist> should be delimited by TAB.\n".
                "\tIf <col> is missing, new data will be inserted into the last column\n".
		"\tMissing value will be printed as NA\n";

if(not defined $ind_val) {
	die($usage);
}

$id_list --;
$id_ref --;
$ind_val--;
if(not defined $col){
	$col = 0;
}elsif($col < 1){
	die("Error: <Col> must be at least 1\n$usage");
}
$col --;

open(IN, $reflist) || die("Error: Cannot open file $reflist.\n");
my $ref_id;
while(my $line = <IN>){
	if ($line =~ /^#/){next;}
	chomp $line;
	my @all = split("\t", $line);
	${$ref_id->{$all[$id_ref]}} = $all[$ind_val];
}
close(IN);

my @lines;
open(IN, $list);
while(my $line = <IN>){
	if ($line =~ /^#/){next;}
	chomp $line;
	my @all = split("\t", $line);
	my $new;
	if(not defined ${$ref_id->{$all[$id_list]}}){
		$new = "NA";
	}else{
		$new = ${$ref_id->{$all[$id_list]}};
	}
	if($col < 0){
		push @all, $new;
	}else{
		splice @all, $col, 0, $new;
	}
	push @lines, join("\t",@all);
}
close(IN);

open(OUT, ">$list");
print OUT join("\n", @lines)."\n";
close(OUT);

exit;
