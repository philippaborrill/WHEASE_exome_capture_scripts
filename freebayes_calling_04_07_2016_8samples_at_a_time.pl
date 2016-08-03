#!/usr/bin/perl -w

# Philippa.borrill@jic.ac.uk
#
# Aim of script is to call snps with samtools
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $read_path = "exome_capture_data_july_2015/PKG_ENQ-718_50_wheat_exomes_data_transfer/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa";

my $output_dir = "$path/exome_capture_analysis/bowtie2_very_sens_replaced_ambig";

my $mismatches = "very_sens_loc";


### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $list_of_sets_of_samples = 'list_of_sets_of_samples.txt';


#open the input file and go through the lines one by one so go to each directories where the fastq.gz should be located
chdir("$output_dir") or die "couldn't move to output directory";

open (INPUT_FILE, "$list_of_sets_of_samples") || die "couldn't open the input file $list_of_sets_of_samples!";
		    while (my $line = <INPUT_FILE>) {
			chomp $line;
my @array = split(/\t/,$line);
#print "\nmy line was: $line\n";
			
#print "\nmy array: @array\n";
#print "\narray element 1: @array[0]\n";

my $set_of_samples = $array[0];
my $samples = $array[1];


chdir("$output_dir") or die "couldn't move to specific read directory";

my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel  freebayes variant calling
#
#SBATCH -p nbi-long # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 60000 # memory pool for all cores
#SBATCH -t 28-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/sets_of_freebayes_variant_calling.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/sets_of_freebayes_variant_calling.JOBNAME.%N.%j.err # STDERR
#SBATCH -J JOBNAME_freebayes
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/freebayes_variant_calling_slurm_04_07_2016.$set_of_samples";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$set_of_samples/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source samtools-0.1.19\n";
  print SLURM "source freebayes-1.0.2\n";

# --use-best-n-alleles 2 = only allow sites with up to 2 alleles (helps reduce memory usage)
# --min-alternate-count 3 = only allow sites which are supported by at least 3 reads (helps reduce memory usage)
# --min-mapping-quality 7 = only use reads with MAPQ>7
# --min-base-quality 20 = only use bases with quality > 20
# --report-monomorphic = report all positions (including those which don't vary from reference)

print SLURM "srun freebayes -f $ref --use-best-n-alleles 2 --min-mapping-quality 7 --min-base-quality 20 --report-monomorphic $samples > freebayes.$set_of_samples"."_MAPQ7.vcf \n";

 
  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















