#! /usr/bin/perl 
use strict;
use warnings;

my %hash1;my %hash2; my %hash3; 

open(my $fh1 => 'Nc3H.expr.tab') || die $!;
open(my $fh2 => 'Nc20H.expr.tab') || die $!;
open(my $fh3 => 'Ncrassa_OR74A_InterproDomains.tab') || die $!;

print "Gene_Id\t Chromo\t Startpos\t genlength\t FPKM_3H\t FPKM_20H\t domainname\n";

while(<$fh1>) {

 my @row = split("\t",$_);

 next if $row[0] eq 'gene_id'; # skip when it is the header line

 my @values = ($row[2],$row[3],$row[4]-$row[3],$row[5]);

 $hash1{$row[0]} = \@values;
}
#print $hash1{NCU06409}->[1];

while(<$fh2>) {

    my @row = split("\t",$_);

    next if $row[0] eq 'gene_id'; # skip when it is the header line

    my @values = ($row[5]);

    $hash2{$row[0]} = \@values;
}

while(<$fh3>) {
  
  my @row = split("\t",$_);
  
  push @{$hash3{$row[0]}} , $row[1];
}
print $hash3{NCU06409}->[0];

foreach my $key(keys %hash1){
    
    print $key."\t".${$hash1{$key}}[0]."\t".${$hash1{$key}}[1]."\t".${$hash1{$key}}[2]."\t".${$hash1{$key}}[3]."\t".${$hash2{$key}}[0]."\t";
    #if ( exists $hash3{$key}) {print ${$hash3{$key}}[0]."\n";??}
    
    if (exists $hash3{$key}) {
	
		for(my $i=0;$i< scalar (@{$hash3{$key}});$i++){
	
		  print $hash3{$key}->[$i]."\t";
		}
    }
    print "\n";
}

# sorted by gene length
open(my $outfh1 => '>genes_sorted_by_length.tab') || die $!;

#another way:print $outfh1 "Gene_Id\t Chromo\t Startpos\t genlength\t FPKM_3H\t FPKM_20H\t domainname\n";
print $outfh1 join("\t", qw(Gene_Id Chromo Startpos Genlength FPKM_3H FPKM_20H domainname)),"\n";

foreach my $key (sort {$hash1{$a}->[2] <=> $hash1{$b}->[2]} keys %hash1) {
	
	print $outfh1 join("\t", $key, $hash1{$key}->[0],$hash1{$key}->[1],$hash1{$key}->[2],$hash1{$key}->[3],$hash2{$key}->[0]); # The same with the last section
	
	if (exists $hash3{$key}) {
	
		for(my $i=0;$i< scalar (@{$hash3{$key}});$i++){
	
			print $outfh1 "\t".$hash3{$key}->[$i];
		}
	}

	print $outfh1 "\n";
}

# sorted by Nc3H FPKM value(highest to lowest $b<=>$a)

open(my $outfh2 => '>genes_sorted_by_FPKM_3H.tab') || die $!;

print $outfh2 join("\t", qw(Gene_Id Chromo Startpos Genlength FPKM_3H FPKM_20H domainname)),"\n";

foreach my $key (sort {$hash1{$b}->[3] <=> $hash1{$a}->[3]} keys %hash1) {

  print $outfh2 join("\t", $key, $hash1{$key}->[0],$hash1{$key}->[1],$hash1{$key}->[2],$hash1{$key}->[3],$hash2{$key}->[0]); 

	if (exists $hash3{$key}) {
	
		for(my $i=0;$i< scalar (@{$hash3{$key}});$i++){
	
			print $outfh2 "\t".$hash3{$key}->[$i];
		}
	}

	print $outfh2 "\n";
}

# sorted by Nc20H FPKM value(highest to lowest $b<=>$a)


open(my $outfh3 => '>genes_sorted_by_FPKM_20H.tab') || die $!;

print $outfh3 join("\t", qw(Gene_Id Chromo Startpos Genlength FPKM_3H FPKM_20H domainname)),"\n";

foreach my $key (sort {$hash2{$b}->[0] <=> $hash2{$a}->[0]} keys %hash2) {

  print $outfh3 join("\t", $key, $hash1{$key}->[0],$hash1{$key}->[1],$hash1{$key}->[2],$hash1{$key}->[3],$hash2{$key}->[0]); 

	if (exists $hash3{$key}) {
	
		for(my $i=0;$i< scalar (@{$hash3{$key}});$i++){
	
			print $outfh3 "\t".$hash3{$key}->[$i];
		}
	}

	print $outfh3 "\n";
}

# sorted by chromosome name and start position

open(my $outfh4 => '>genes_sorted_by_Multiple.tab') || die $!;

print $outfh4 join("\t", qw(Gene_Id Chromo Startpos Genlength FPKM_3H FPKM_20H domainname)),"\n";

foreach my $key (sort { $hash1{$a}->[0].$hash1{$a}->[1] cmp $hash1{$b}->[0].$hash1{$b}->[1]} keys %hash1) {

print $outfh4 join("\t", $key, $hash1{$key}->[0],$hash1{$key}->[1],$hash1{$key}->[2],$hash1{$key}->[3],$hash2{$key}->[0]); 

	if (exists $hash3{$key}) {
	
		for(my $i=0;$i< scalar (@{$hash3{$key}});$i++){
	
			print $outfh4 "\t".$hash3{$key}->[$i];
		}
	}

	print $outfh4 "\n";
}














