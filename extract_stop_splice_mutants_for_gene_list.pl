#!/nbi/software/production/perl/5.16.2/x86_64/bin/perl/ -w

use strict;
use diagnostics;

# Aim of this script is to take a file with gene names in a column and find all STOP and splice (acceptor or donor) mutants in those genes. It puts the mutations for each gene into a new file named the gene name. It then makes a text file ($count_file) which has the final output which is a list of all genes with the number of mutations in them gene.

## need to alter this script to have correct $input_file and correct $mutation_file

my $path = "/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/";

my $dir = "/TILLING_data/Kronos/";

my $input_file = "Wheat_genes_from_Arabidopsis_genes.txt"; #contains list of genes to look for mutations in - put inside $path/$dir

#my $mutation_file = "test_variants.txt";
my $mutation_file = "Kronos_TILLING_STOP_splice_acceptor_and_donor_variants.txt";

my $count_file = "OUTPUT_mutations_per_gene_$input_file"."_$mutation_file";

my $count;

#my $mutation_file ="Kronos_TILLING_STOP_splice_acceptor_and_donor_variants.txt"; #contains all stop and splice mutations in all genes - put inside $path/$dir



#change to directory containing the text files
chdir ("$path/$dir") or die;

#first print to final output file what the inputs were:
open (COUNTFILE, ">>$count_file") or die "Cannot open file $count_file to write to\n\n";
print COUNTFILE "Inputfile was: $input_file\n";
print COUNTFILE "Mutation file was: $mutation_file\n";
close (COUNTFILE);

#open the text file
open(GENES,"$input_file") or die "Could not open $input_file: $!";

while (my $line = <GENES>){
	print $line;
	chomp $line;
    	
	open(MUTATIONS, "$mutation_file") or die "Could not open $mutation_file: $!";
	while (my $mutation = <MUTATIONS>){
		#print $mutation;
		if ($mutation =~ /$line/) {
			my $outputfile = "$line.txt";
				open(OUTPUT, ">>$outputfile") or die "Cannot open file $outputfile to write to\n\n";
			    	print OUTPUT "$mutation";
				close(OUTPUT);	
			}
		}
#step to count number of lines in each output file (ie number of mutations in that gene)

#check if $line.txt exists
if (-e "$line.txt"){

open(OUTPUT, "< $line.txt") or die "can't open $line.txt: $!";
my $count;
$count++ while <OUTPUT>;
print "$count\n";

open (COUNTFILE, ">>$count_file") or die "Cannot open file $count_file to write to\n\n";
print COUNTFILE join("\t",$line,$count)."\n";
close (COUNTFILE);
close (OUTPUT);
}

#if $line.txt doesn't exist print 0 to $count_file
else {
open (COUNTFILE, ">>$count_file") or die "Cannot open file $count_file to write to\n\n";
print COUNTFILE join("\t",$line,"0")."\n";
close (COUNTFILE);	
}

}
close(MUTATIONS);
close(GENES);



# then move directory to the output directory and use "wc -l Traes*" to count the number of mutant lines found for each gene with a stop or 
	
