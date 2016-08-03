#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to align reads from exome capture for multiple samples to a common reference using bwa-aln
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/';

my $read_path = "/nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/Momina/PKG_fastq_files_for_6_lines_from_PlateA/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome";
my $ref2 = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/bowtie2";

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
#BSUB -q NBI-Prod128
#BSUB -J bowtie2_JOBNAME
#BSUB -R "rusage[mem=10000]"
#BSUB -n 8
LSF


 my $tmp_file = "$output_dir/tmp/bowtie2_paired_lsf.Cad.$dir";

  open (BSUB, ">$tmp_file") or die "Couldn't open temp file\n";
  $bsub_header =~ s/JOBNAME/$output/;
  print BSUB "$bsub_header\n\n";
  print BSUB "\ncd $read_path/$dir\n";

#source and run bowtie2 with paired ends, max insert size 500, 8 threads
  print BSUB "source bowtie2-2.2.4\n";
    print BSUB "bowtie2 -p 8 -X 500 -x $ref -1 $pair_1_R1 -2 $pair_1_R2 -S $output_dir/$output"."_n$mismatches.sam\n";

#source picard
  print BSUB "source picard-1.134\n";

# merge mapped bam with unmapped bam to get "clean" file, flagstat
  print BSUB "picard MergeBamAlignment ALIGNED=$output_dir/$output"."_n$mismatches.sam UNMAPPED=$path/exome_capture_analysis/fastqtosam/$output.fastqtosam.bam OUTPUT=$output_dir/$output"."_MergeBamAlignment.bam REFERENCE_SEQUENCE=$ref2\n";
  print BSUB "samtools flagstat $output_dir/$output"."_MergeBamAlignment.bam > $output_dir/$output"."_MergeBamAlignment.flagstat.txt\n";
  close BSUB;

# convert sam to bam and sort by coordinate, make flagstat
  print BSUB "picard SortSam INPUT=$output_dir/$output"."_n$mismatches.sam OUTPUT=$output_dir/$output"."_n$mismatches.sorted.bam SORT_ORDER=coordinate CREATE_INDEX=true\n";
  print BSUB "samtools flagstat $output_dir/$output"."_n$mismatches.sorted.bam > $output_dir/$output"."_n$mismatches.sorted.flagstat.txt\n";

# mark duplicates in file and flagstat
  print BSUB "picard MarkDuplicates INPUT=$output_dir/$output"."_n$mismatches.sorted.bam OUTPUT=$output_dir/$output"."_n$mismatches.sorted.markdup_rm.bam METRICS_FILE=$output_dir/$output"."_n$mismatches.sorted.markdup_metrics REMOVE_DUPLICATES=true ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 TMP_DIR=$path/tmp\n";
  print BSUB "samtools flagstat $output_dir/$output"."_n$mismatches.sorted.markdup_rm.bam > $output_dir/$output"."_n$mismatches.sorted.markdup_rm.flagstat.txt\n";



  system("bsub < $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















