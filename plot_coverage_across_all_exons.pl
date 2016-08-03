#!/usr/bin/perl -w

# Philippa.borrill@jic.ac.uk
#
# Aim of script is to convert fastq to ubam
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/bwa-aln";

my $mismatches = "5";

### input info: contains 4 tab separated columns with: directory, R1, R2, sample_name
### must be in $output_dir
my $exome_capture_paired_list = 'input_for_picard_FastqtoSam_only_sample1.txt';


#open the input file and go through the lines one by one so go to each directories where the fastq.gz should be located
chdir("$output_dir") or die "couldn't move to output directory";

open (INPUT_FILE, "$exome_capture_paired_list") || die "couldn't open the input file $exome_capture_paired_list!";
		    while (my $line = <INPUT_FILE>) {
			chomp $line;
my @array = split(/\t/,$line);

my $dir = $array[0];
my $pair_1_R1 = $array[1];
my $pair_1_R2 = $array[2];
my $output = $array[3];
my $lib = $array[4];
my $sample = $array[5];
my $platform_unit = $array[6];

chdir("$output_dir") or die "couldn't move to specific read directory";

my $SLURM_header = <<"SLURM";
#!/bin/bash
#
# SLURM batch script to launch parallel bedtools tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o $output_dir/slurm_output/slurm.bedtools_coverage.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/slurm.bedtools_coverage.JOBNAME.%N.%j.err # STDERR
#SBATCH -J bedtools_coverage_slurm_JOBNAME
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/bedtools_coverage_slurm_24_3_2016.$output";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir\n";

# source programmes
  print SLURM "source samtools-0.1.19\n";
  print SLURM "source bedtools-2.17.0\n";

# only keep reads over MAPQ20 using samtools view -q 20
# calculate coverage histogram using bedtools coverage across only exons

print SLURM "srun /usr/users/metbio/borrillp/bin/samtools view -q 10 -u $output_dir/with_bam_header/$sample".".MergeBam.cleaned.markdup_rm.merged_markdup_rm_2nd_time.bam | bedtools coverage -hist -abam stdin -b $path/IWGSC_exons_only.gtf | grep ^all > $output_dir/with_bam_header/$sample"."bam.hist.all_q10.txt \n";

  close SLURM;
  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















