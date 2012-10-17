#! /usr/bin/perl -w
use strict;

open(my $fh1 => 'ath_chr1.gff.txt') || die $!;

#1 2  number of 3'UTRs and average length of genes
my $i = 0;my $j = 0; my $sum = 0;

my %hash; my $number=0;

while(<$fh1>) {

 my @row = split("\t",$_);

    if ($row[2] eq 'three_prime_UTR')     {$i++;}
   
    if ($row[2] eq 'gene')
    {
		if (($row[6] eq '+') && ($row[3] >= 1001300) && ($row[4] <= 10000500))

        {$sum = $sum + $row[4] - $row[3];

            $j++;   #print $j;
        }
    }


# 3 number of introns


    next if $row[2] ne "exon" ;
    
       my $key= $row[8];
    
    if(substr($key,17,1) == 1){ 
        
       push @{$hash{$key}}, $row[3];
    
       push @{$hash{$key}}, $row[4];
    
        if( scalar @{$hash{$key}} > 3) {
    
            my $intron_length = ${$hash{$key}}[2] - ${$hash{$key}}[1];
    
            if($intron_length >= 100 && $intron_length <= 300) {
    
                $number++;
            }
    
            shift @{$hash{$key}};
    
            shift @{$hash{$key}};
        }
     }
}
open(my $outfh => '>ath_chr1_stats.txt') || die $!;

my $average = $sum/$j;

print $outfh $i."\t".$number."\t";

printf $outfh ("%d",$average);



 




=cut
# average length of the genes_ confliction
my $j = 0; my $sum = 0;
while(<$fh1>) {
   my @row = split("\t",$_);
    if ($row[2] eq 'gene')
    {
		if (($row[6] eq '+') && ($row[3] >= 1001300) && ($row[4] <= 10000500))
		  {$sum = $sum + $row[4] - $row[3];
		  $j++;
              print $j;
          }
    }
}
my $average = $sum/$j;
printf ("The average of gene length is %d",$average);
 

