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

# LOOP 1 ############ this is for the 57 varieties I sequenced#############(see below for hapmap loop)

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_picard_FastqtoSam_only_sample1.txt';


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

chdir("$output_dir") or die "couldn't move to specific read directory";

my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel  samtools variant calling
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/samtools_index_slurm_.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/samtools_index_slurm_.JOBNAME.%N.%j.err # STDERR
#SBATCH -J JOBNAME_samtools_index_slurm
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/samtools_index_slurm_23_06_2016.$output";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source samtools-0.1.19\n";

print SLURM "srun samtools index $output_dir/$sample".".MergeBam_merged_markdup_rm_2nd_time.bam $output_dir/$sample".".MergeBam_merged_markdup_rm_2nd_time.bai \n";

  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 


# LOOP 2 ############ this is for the hapmap loop data ################

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list_hapmap = 'input_for_picard_FastqtoSam_hapmap.txt';


#open the input file and go through the lines one by one so go to each directories where the fastq.gz should be located
chdir("$output_dir") or die "couldn't move to output directory";

open (INPUT_FILE, "$exome_capture_paired_list_hapmap") || die "couldn't open the input file $exome_capture_paired_list_hapmap!";
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

chdir("$output_dir") or die "couldn't move to specific read directory";

my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel samtools variant calling
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/samtools_index_slurm_.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/samtools_index_slurm_.JOBNAME.%N.%j.err # STDERR
#SBATCH -J JOBNAME_samtools_index_slurm
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/samtools_index_slurm_23_06_2016.$output";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source samtools-0.1.19\n";

print SLURM "srun samtools index $output_dir/$sample"."_MergeBamAlignment.bam $output_dir/$sample"."_MergeBamAlignment.bai \n";


  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 



















