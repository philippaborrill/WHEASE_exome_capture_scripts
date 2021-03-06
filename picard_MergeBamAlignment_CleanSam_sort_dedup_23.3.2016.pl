#!/usr/bin/perl -w

# Philippa.borrill@jic.ac.uk
#
# Aim of script is to convert fastq to ubam
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $read_path = "exome_capture_data_march_2016/PKG_ENQ-718_50_wheat_exomes_data_transfer/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/bwa-aln";

my $mismatches = "5";

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_picard_FastqtoSam_4_samples_repeat.txt';


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
# SLURM batch script to launch parallel bwa tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/slurm.picard_MergeBam_Alignment_CleanSam_sort_dedup.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/slurm.picard_MergeBam_Alignment_CleanSam_sort_dedup.JOBNAME.%N.%j.err # STDERR
#SBATCH -J picard_MergeBam_Alignment_CleanSam_sort_dedup_JOBNAME
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/picard_MergeBam_Alignment_CleanSam_sort_dedup_slurm_24_3_2016.$output";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source picard-1.134\n";
  print SLURM "source samtools-0.1.19\n";

# clean sam to make unmapped reads have MAPQ0
  print SLURM "picard CleanSam INPUT=$output_dir/no_bam_header/$output"."_n5.sorted.bam OUTPUT=$output_dir/no_bam_header/$output"."_n5.cleaned.bam\n";  
  print SLURM "samtools flagstat $output_dir/no_bam_header/$output"."_n5.cleaned.bam > $output_dir/no_bam_header/$output"."_n5.cleaned.flagstat.txt\n";

## merge ubam and bam to get read header info
  print SLURM "picard MergeBamAlignment ALIGNED=$output_dir/no_bam_header/$output"."_n5.cleaned.bam UNMAPPED=$path/exome_capture_analysis/fastqtosam/$output.fastqtosam.bam OUTPUT=$output_dir/with_bam_header/$output".".MergeBam.cleaned.bam VALIDATION_STRINGENCY=LENIENT REFERENCE_SEQUENCE=$ref\n\n";
  print SLURM "samtools flagstat $output_dir/with_bam_header/$output".".MergeBam.cleaned.bam > $output_dir/with_bam_header/$output".".MergeBam.cleaned.flagstat.txt\n";

# remove duplicates
  print SLURM "picard MarkDuplicates INPUT=$output_dir/with_bam_header/$output".".MergeBam.cleaned.bam OUTPUT=$output_dir/with_bam_header/$output".".MergeBam.cleaned.markdup_rm.bam METRICS_FILE=$output_dir/with_bam_header/$output".".MergeBam.cleaned.markdup_metrics REMOVE_DUPLICATES=TRUE ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 TMP_DIR=$path/tmp\n";

  print SLURM "samtools flagstat $output_dir/with_bam_header/$output".".MergeBam.cleaned.markdup_rm.bam > $output_dir/with_bam_header/$output".".MergeBam.cleaned.markdup_rm.flagstat.txt\n";


  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















