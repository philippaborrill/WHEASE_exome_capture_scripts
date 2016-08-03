#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to convert fastq to ubam
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $read_path = "exome_capture_analysis/hapmap/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa";

my $output_dir = "$path/exome_capture_analysis/";

my $mismatches = "5";

### input info: contains 7 tab separated columns with: directory, R1, R2, output_name, lib, sample_name, platform_unit
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_picard_FastqtoSam_hapmap.txt';


#open the input file and go through the lines one by one so go to each directories where the fastq.gz should be located
chdir("$output_dir") or die "couldn't move to output directory";

open (INPUT_FILE, "$exome_capture_paired_list") || die "couldn't open the input file $exome_capture_paired_list!";
		    while (my $line = <INPUT_FILE>) {
			chomp $line;
my @array = split(/\t/,$line);
#print "\nmy line was: $line\n";
			
#print "\nmy array: @array\n";
#print "\narray element 1: @array[0]\n";

my $dir = $array[0];
my $pair_1_R1 = $array[1];
my $pair_1_R2 = $array[2];
my $output = $array[3];
my $lib = $array[4];
my $sample = $array[5];
my $platform_unit = $array[6];

#print "$path/$read_path/$dir\n";

chdir("$path/$read_path/") or die "couldn't move to specific read directory";

### slurm header including memory usage request
my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel bwa tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/bowtie2_very_sens_replaced_ambig/slurm_output/slurm.FastqtoSam.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/bowtie2_very_sens_replaced_ambig/slurm_output/slurm.FastqtoSam.JOBNAME.%N.%j.err # STDERR
#SBATCH -J FastqtoSam_JOBNAME
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/bowtie2_very_sens_replaced_ambig/tmp/picard_FastqtoSam_02_06_2016.$dir";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $path/$read_path/\n";

## convert fastq to sam
  print SLURM "source picard-1.134\n";
  print SLURM "picard FastqToSam FASTQ=$pair_1_R1 FASTQ2=$pair_1_R2 OUTPUT=$output_dir/$output.fastqtosam.bam READ_GROUP_NAME=$output SAMPLE_NAME=$sample LIBRARY_NAME=$lib PLATFORM=illumina PLATFORM_UNIT=$platform_unit\n";
  
  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















