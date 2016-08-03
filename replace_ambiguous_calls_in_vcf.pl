#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to remove ambiguous calls from vcf

my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis';

my $input_vcf = 'body_inter_hom_var_ensembl.vcf';
my $output_file = 'body_inter_hom_var_ensembl_removed_ambig_var.vcf';

chdir("$path") or die "couldn't move to specific directory";

#open the input file

open (INPUT_FILE, "$input_vcf") || die "couldn't open the input file $input_vcf!";
		    while (my $line = <INPUT_FILE>) {
			chomp $line;
my @array = split(/\t/,$line);
#print "\nmy line was: $line\n";
			
#print "\nmy array: @array\n";
#print "\narray element 1: @array[0]\n";

my $col1 = $array[0];
my $col2 = $array[1];
my $col3 = $array[2];
my $col4 = $array[3];
my $col5 = $array[4];
my $col6 = $array[5];
my $col7 = $array[6];
my $col8 = $array[7];

$col4 =~ s/[^A|C|G|T]/N/g;
$col5 =~ s/[^A|C|G|T]/N/g;

open(OUTPUT, ">>$output_file");
print OUTPUT "$col1\t$col2\t$col3\t$col4\t$col5\t$col6\t$col7\t$col8\n";
close OUTPUT;
#print "done\n";

## need to close loop 
	}
	    close(INPUT_FILE); 





















