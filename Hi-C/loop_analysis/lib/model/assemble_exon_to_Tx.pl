#!/usr/bin/perl

use strict;
my $usage = 	"./assemble_exon_to_Tx.pl <exon_bed> <cds_bed>\n".
		"\tThis program assemble Tx bed file from exon bed file\n".
		"\tEach line of <exon_bed> is an exon, FORMAT:chr,beg,end,gene_id,gene_name,strand.\n".
		"\t<cds_bed> is bed file list the cds of each gene, 4th column is id\n".
		"\t<exon_bed> and <cds_bed> must be sorted first by gene_id, then beg, using sort -k4,4 -k2,2n\n".
		"\tOverlapping exon or cds will be merged while assembling\n";

my ($exon_file, $cds_file) = @ARGV;
if(not defined $cds_file){
	die($usage);
}

my $Tx;
open(IN, $exon_file);
my $prev_id = "";
while(my $line = <IN>){
        chomp $line;
        my ($chr, $beg, $end, $gid, $gname, $strand) = split "\t", $line;
	if(not defined $gname){
		$gname = $gid;
	}
	if(not defined $strand){
		$strand = "+";
	}
	
	if($gid ne $prev_id){
		if(defined $Tx->{"chr"}->{$gid}){
			die("Error: Exon file must be sorted by gene id first!\n".$usage);
		}
		$Tx->{"chr"}->{$gid} = $chr;
		$Tx->{"name"}->{$gid} = $gname;
		$Tx->{"strand"}->{$gid} = $strand;
		push @{$Tx->{"exon_beg"}->{$gid}}, $beg;
		push @{$Tx->{"exon_end"}->{$gid}}, $end;
		$prev_id = $gid;
	}else{
		my $len = $#{$Tx->{"exon_beg"}->{$gid}};
		my $last_beg = ${$Tx->{"exon_beg"}->{$gid}}[$len];
		my $last_end = ${$Tx->{"exon_end"}->{$gid}}[$len];
		if($chr ne $Tx->{"chr"}->{$gid}){
			die("Error: Exons from the same gene should be on the same chromosome!\n".$usage);
		}
		if($beg < $last_beg){
			die("Error: Exons of the same gene must be sorted by their begin locations!\n".$usage);
		}
		if($beg > $last_end + 1){
			push @{$Tx->{"exon_beg"}->{$gid}}, $beg;
			push @{$Tx->{"exon_end"}->{$gid}}, $end;
		}else{
			${$Tx->{"exon_end"}->{$gid}}[$len] = ($last_end > $end) ? $last_end : $end;
		}
	}
	
}
close(IN);

open(IN, $cds_file);
my $prev_id = "";
while(my $line = <IN>){
	chomp $line;
	my ($chr, $beg, $end, $gid, $gname, $strand) = split "\t", $line;
	if(not defined $Tx->{"chr"}->{$gid}){
		die("Error: GeneID in the cds file must be included in the exon file!\n");
	}
	if($gid ne $prev_id){
		if(defined $Tx->{"cds_beg"}->{$gid}){
			die("Error: CDS file must be sorted by gene id first!\n".$usage);
		}
                $Tx->{"cds_beg"}->{$gid} = $beg;
                $Tx->{"cds_end"}->{$gid} = $end;
                $prev_id = $gid;
        }else{
                my $last_beg = $Tx->{"cds_beg"}->{$gid};
                my $last_end = $Tx->{"cds_end"}->{$gid};
                if($chr ne $Tx->{"chr"}->{$gid}){
                        die("Error: Same geneid should be on the same chromosome!\n".$usage);
                }
                if($beg < $last_beg){
                        die("Error: CDS of the same gene must be sorted by their begin locations!\n".$usage);
                }
                if($beg > $last_end + 1){
			die("Error: One gene may have only one CDS!\n".$usage);
                }else{
                        $Tx->{"cds_end"}->{$gid} = ($last_end > $end) ? $last_end : $end;
                }
        }
}
close(IN);

foreach my $gid (keys %{$Tx->{"chr"}}){
	my $count = $#{$Tx->{"exon_beg"}->{$gid}} + 1;
	my $chr = $Tx->{"chr"}->{$gid};
	my $tss = ${$Tx->{"exon_beg"}->{$gid}}[0] - 1;
	my $tes = ${$Tx->{"exon_end"}->{$gid}}[$count - 1];
	my $name = $Tx->{"name"}->{$gid};
	my $score = 0;
	my $strand = $Tx->{"strand"}->{$gid};

	my $thickStart = $tes;
	my $thickEnd = $tes;
	if(defined $Tx->{"cds_beg"}->{$gid}){
		$thickStart = $Tx->{"cds_beg"}->{$gid} - 1;
		$thickEnd = $Tx->{"cds_end"}->{$gid};
	}

	my $RGB = 0;
	my @blockSizes = ();
	my @blockStarts = ();
	for(my $i=0; $i<$count; $i++){
		push @blockStarts, ${$Tx->{"exon_beg"}->{$gid}}[$i] - $tss - 1;
		push @blockSizes, ${$Tx->{"exon_end"}->{$gid}}[$i] - ${$Tx->{"exon_beg"}->{$gid}}[$i] + 1;
	}
	
	print join("\t", $chr, $tss, $tes, $name, $gid, $strand, $thickStart, $thickEnd, $RGB, $count, join(",",@blockSizes), join(",", @blockStarts))."\n";
}

exit;

