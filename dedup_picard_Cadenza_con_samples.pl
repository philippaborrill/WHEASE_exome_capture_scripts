#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to align reads from exome capture for multiple samples to a common reference using bwa-aln
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/';

my $output_dir = "$path/exome_capture_analysis/";

my $mismatches = "5";

### input info: contains 1 columns withsample_name
### must be in $output_dir
my $sample_list = 'sample_list_Cad_control.txt';


#open the input file and go through the lines one by one so go to each directories where the fastq.gz should be located
chdir("$output_dir") or die "couldn't move to output directory";

open (INPUT_FILE, "$sample_list") || die "couldn't open the input file $sample_list!";
		    while (my $line = <INPUT_FILE>) {
			chomp $line;
my $sample = $line;

#print "$path/$read_path/$dir\n";

### bsub header including memory usage request
my $bsub_header = <<"LSF";
#!/bin/bash
#
# LSF batch script to launch parallel samtools tasks
#
#BSUB -q NBI-Prod128
#BSUB -J samtools_JOBNAME
#BSUB -R "rusage[mem=10000]"
#BSUB -n 8
LSF


 my $tmp_file = "$output_dir/tmp/picard_lsf.$sample";

  open (BSUB, ">$tmp_file") or die "Couldn't open temp file\n";
  $bsub_header =~ s/JOBNAME/$sample/;
  print BSUB "$bsub_header\n\n";
  print BSUB "\ncd $output_dir\n";

  print BSUB "source samtools-0.1.19\n";

# remove duplicates and index
  print BSUB "source picard-1.134\n";
  print BSUB "picard MarkDuplicates INPUT=$sample"."_n$mismatches.sorted.bam OUTPUT=$sample"."_n$mismatches.sorted.markdup_rm.bam METRICS_FILE=$sample"."_n$mismatches.sorted.markdup_metrics REMOVE_DUPLICATES=true ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 TMP_DIR=$path/tmp\n";
  print BSUB "samtools index $sample"."_n$mismatches.sorted.markdup_rm.bam $sample"."_n$mismatches.sorted.markdup_rm.bai\n";
  print BSUB "samtools flagstat $sample"."_n$mismatches.sorted.markdup_rm.bam > $sample"."_n$mismatches.sorted.markdup_rm.flagstat.txt\n";


  close BSUB;
  system("bsub < $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the samples in the list
	}
	    close(INPUT_FILE); 




















