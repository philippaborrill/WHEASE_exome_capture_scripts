#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to convert fastq to ubam
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/';

my $read_path = "exome_capture_data_july_2015/PKG_ENQ-718_50_wheat_exomes_data_transfer/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/";

my $mismatches = "5";

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_picard_FastqtoSam.txt';


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

### bsub header including memory usage request
my $bsub_header = <<"LSF";
#!/bin/bash
#
# LSF batch script to launch parallel picard tasks
#
#BSUB -q NBI-Prod128
#BSUB -J picard_MergeBamAlign_JOBNAME
#BSUB -R "rusage[mem=10000]"
#BSUB -n 8
LSF


 my $tmp_file = "$output_dir/tmp/picard_MergeBamAlignment_lsf_25-2-2016.$output";

  open (BSUB, ">$tmp_file") or die "Couldn't open temp file\n";
  $bsub_header =~ s/JOBNAME/$output/;
  print BSUB "$bsub_header\n\n";
  print BSUB "\ncd $output_dir\n";

## convert fastq to sam
  print BSUB "source picard-1.134\n";
  print BSUB "picard MergeBamAlignment ALIGNED=$output_dir/no_bam_header/$output"."_n5.sorted.bam UNMAPPED=$output_dir/$output.fastqtosam.bam OUTPUT=$output_dir/$output"."_MergeBamAlignment.bam REFERENCE_SEQUENCE=$ref\n";
  
  close BSUB;
  system("bsub < $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















