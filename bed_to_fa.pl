#!/nbi/software/production/perl/5.16.2/x86_64/bin/perl/ -w

use strict;
use diagnostics;
use lib "/nbi/software/testing/bioperl/1.6.1/src/BioPerl-1.6.1/";
use Bio::Perl;
use Bio::AlignIO;


##NB##################################
# 
# Input files in bed format (3 column) 
# make sure $dir is the directory containing bed files you want extract fa for 

my $path = "/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/";

my $dir = "/promoter_sequences_for_karunesh/";


push my @files, `ls -1 $path/$dir/*.bed`;

for my $file (@files){
	print "file =  $file\n";
	chop $file;

chdir ("$path/$dir")or die;

#1) extract regions in bed from wheat_pseudo_v3.fasta, put these into a new fasta file, use samtools faidx
#creates output of fasta file with all regions and their sequence in one file


open(POSITIONS,"$file") or die "Could not open $file: $!";

while (my $line = <POSITIONS>){
    
	#print "\nline read in: " .$line;
	 my   ($chromName, $IWGSC, $type, $begin, $end, $dot) = split('\s+', $line);

  open(SAMTOOLS,"samtools faidx $path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa $chromName:$begin-$end |");
    while(my $line = <SAMTOOLS>){
	my $outputfile = "$file.fasta";
	open(OUTPUT, ">>$outputfile") or die "Cannot open file $outputfile to write to\n\n";
    	print $line;
	print OUTPUT $line;
	close(OUTPUT);		 
	}
    close(SAMTOOLS);
}
close(POSITIONS);
}
print "\nregions extracted successfully from bed file\n";






