#!/usr/bin/perl -w

# Re-engineered to use LSF properly
# Philippa.borrill@jic.ac.uk
#
# Aim of script is to align reads from exome capture for multiple samples to a common reference using bwa-aln
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $read_path = "exome_capture_analysis/hapmap/";
my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases";
my $ref2 = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa";

my $output_dir = "$path/exome_capture_analysis/bowtie2_very_sens_replaced_ambig";

my $mismatches = "very_sens_loc";

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_bowtie2_hapmap.txt';


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

chdir("$path/$read_path") or die "couldn't move to specific read directory";

### slurm header including memory usage request
my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel bwa tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 2 # number of cores
#SBATCH --mem 20000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/slurm.bowtie2_very_sens_loc_sort_dedup_MergeBam.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/slurm.bowtie2_very_sens_loc_sort_dedup_MergeBam.JOBNAME.%N.%j.err # STDERR
#SBATCH -J JOBNAME_bowtie2_very_sens_loc_sort_dedup_MergeBam
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM

 my $tmp_file = "$output_dir/tmp/bowtie2_very_sensitive_local_02_06_2016.$dir";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $path/$read_path\n";

#source and run bowtie2 with paired ends, very-sensitive-local parameters 2 threads
  print SLURM "source bowtie2-2.2.4\n";
  print SLURM "bowtie2 --very-sensitive-local -p 2 -x $ref -1 $pair_1_R1 -2 $pair_1_R2 -S $output_dir/$output"."_n$mismatches.sam\n";

#source picard
  print SLURM "source picard-1.134\n";

# convert sam to bam and sort by coordinate, make flagstat
  print SLURM "samtools view -bS $output_dir/$output"."_n$mismatches.sam > $output_dir/$output"."_n$mismatches.bam \n";
  print SLURM "samtools sort $output_dir/$output"."_n$mismatches.bam $output_dir/$output"."_n$mismatches.sorted\n";
  print SLURM "samtools flagstat $output_dir/$output"."_n$mismatches.sorted.bam > $output_dir/$output"."_n$mismatches.sorted.flagstat.txt\n";
  print SLURM "samtools index $output_dir/$output"."_n$mismatches.sorted.bam $output_dir/$output"."_n$mismatches.sorted.bai\n";

# mark duplicates in file and flagstat
  print SLURM "picard MarkDuplicates INPUT=$output_dir/$output"."_n$mismatches.sorted.bam OUTPUT=$output_dir/$output"."_n$mismatches.sorted.markdup_rm.bam METRICS_FILE=$output_dir/$output"."_n$mismatches.sorted.markdup_metrics REMOVE_DUPLICATES=true ASSUME_SORTED=TRUE VALIDATION_STRINGENCY=LENIENT MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 TMP_DIR=$path/tmp\n";
  print SLURM "samtools flagstat $output_dir/$output"."_n$mismatches.sorted.markdup_rm.bam > $output_dir/$output"."_n$mismatches.sorted.markdup_rm.flagstat.txt\n";

# merge mapped bam with unmapped bam to get "clean" file, flagstat
  print SLURM "picard MergeBamAlignment ALIGNED=$output_dir/$output"."_n$mismatches.sorted.markdup_rm.bam UNMAPPED=$path/exome_capture_analysis/fastqtosam/$output.fastqtosam.bam OUTPUT=$output_dir/$output"."_MergeBamAlignment.bam VALIDATION_STRINGENCY=LENIENT REFERENCE_SEQUENCE=$ref2\n";
  print SLURM "samtools flagstat $output_dir/$output"."_MergeBamAlignment.bam > $output_dir/$output"."_MergeBamAlignment.flagstat.txt\n";




  print SLURM "rm -f $output_dir/$output"."_n$mismatches.sam\n";


  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















