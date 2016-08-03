#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to align reads from exome capture for multiple samples to a common reference using bwa-aln
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/';

my $read_path = "/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/Momina/PKG_fastq_files_for_6_lines_from_PlateA/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/";

my $mismatches = "5";

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_bwa-aln_Cad_con.txt';


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

#print "$path/$read_path/$dir\n";

chdir("$read_path/$dir") or die "couldn't move to specific read directory";

### bsub header including memory usage request
my $bsub_header = <<"LSF";
#!/bin/bash
#
# LSF batch script to launch parallel bwa tasks
#
#BSUB -q NBI-Test128
#BSUB -J bwa-aln_JOBNAME
#BSUB -R "rusage[mem=10000]"
#BSUB -n 8
LSF


 my $tmp_file = "$output_dir/tmp/bwa-aln_paired_lsf.$dir";

  open (BSUB, ">$tmp_file") or die "Couldn't open temp file\n";
  $bsub_header =~ s/JOBNAME/$output/;
  print BSUB "$bsub_header\n\n";
  print BSUB "\ncd $read_path/$dir\n";

  print BSUB "source fastqc-0.10.1\n";
  print BSUB "source samtools-0.1.19\n";

  #if paired end reads:
  print BSUB "fastqc $pair_1_R1 --outdir=$output_dir/fastqc\n";
  print BSUB "fastqc $pair_1_R2 --outdir=$output_dir/fastqc\n";

#using bwa aln, make bam, sort, flagstat, index and remove sam
  print BSUB "source bwa-0.7.12\n";

  print BSUB "bwa aln -t 64 -n $mismatches $ref $pair_1_R1 > $output_dir/$output"."_bwa_R1_n$mismatches.sai\n";
  print BSUB "bwa aln -t 64 -n $mismatches $ref $pair_1_R2 > $output_dir/$output"."_bwa_R2_n$mismatches.sai\n\n";
  print BSUB "bwa sampe $ref $output_dir/$output"."_bwa_R1_n$mismatches.sai $output_dir/$output"."_bwa_R2_n$mismatches.sai $pair_1_R1 $pair_1_R2 > $output_dir/$output"."_n$mismatches.sam\n\n"; 

  print BSUB "samtools view -bS $output_dir/$output"."_n$mismatches.sam > $output_dir/$output"."_n$mismatches.bam\n";
  print BSUB "samtools sort $output_dir/$output"."_n$mismatches.bam $output_dir/$output"."_n$mismatches.sorted\n";
  print BSUB "samtools flagstat $output_dir/$output"."_n$mismatches.sorted.bam > $output_dir/$output"."_n$mismatches.sorted.flagstat.txt\n";
  print BSUB "samtools index $output_dir/$output"."_n$mismatches.sorted.bam $output_dir/$output"."_n$mismatches.sorted.bai\n";
  print BSUB "rm -f $output_dir/$output"."_n$mismatches.sam\n";
  print BSUB "rm -f $output_dir/$output"."_n$mismatches.bam\n";

  close BSUB;
  system("bsub < $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















