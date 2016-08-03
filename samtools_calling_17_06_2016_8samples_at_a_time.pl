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
# SLURM batch script to launch parallel  samtools variant calling
#
#SBATCH -p nbi-long # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 60000 # memory pool for all cores
#SBATCH -t 7-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/sets_of_samtools_variant_calling_slurm_.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/sets_of_samtools_variant_calling_slurm_.JOBNAME.%N.%j.err # STDERR
#SBATCH -J JOBNAME_samtools_variant_calling_slurm
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/samtools_variant_calling_slurm_17_06_2016.$set_of_samples";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$set_of_samples/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source samtools-0.1.19\n";

# options for samtools mpileup
# -A means also include non-paired reads in variant calling
# -Q 20 means only use bases with base quality > 20 for SNP calling
# -u means uncompressed output
# -f is the fasta ref (must already be indexed by samtools)
# -q filter reads only above a certain MAPQ e.g. 20
# -g Compute genotype likelihoods and output them in the binary call format (BCF). 
# -D output per sample read depth

# options for bcftools view
# -b output in BCF format (not VCF)
# -c call variants using Bayesian inference
# -v output variant sites only
# -g call per-sample genotypes at variant sites


print SLURM "srun /usr/users/metbio/borrillp/bin/samtools mpileup -D -A -Q 20 -q 7 -u -g -f $ref $samples | /usr/users/metbio/borrillp/bin/bcftools view -bcg - > samtools.$set_of_samples"."_MAPQ7.raw.bcf \n";

# options for vcfutils.pl varFilter
# -D 1000 max read depth
# -a min alt base reads

print SLURM "/usr/users/metbio/borrillp/bin/bcftools view samtools.$set_of_samples"."_MAPQ7.raw.bcf | /usr/users/metbio/borrillp/bin/vcfutils.pl varFilter -a 3 -D 1000 > samtools.$set_of_samples"."_MAPQ7.flt.vcf \n";

 
  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















