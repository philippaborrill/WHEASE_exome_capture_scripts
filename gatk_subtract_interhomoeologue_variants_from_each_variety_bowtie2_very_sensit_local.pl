#!/usr/bin/perl -w

# Philippa.borrill@jic.ac.uk
#
# Aim of script is to convert fastq to ubam
# Make sure you have bwa index of reference sequence available and in correct path 


my $path = '/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/';

my $ref = "$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa";

my $output_dir = "$path/exome_capture_analysis/bowtie2_very_sensitive";

my $mismatches = "very_sens_loc";

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
#SBATCH -o $output_dir/slurm_output/slurm.gatk_subtract.JOBNAME.%N.%j.out # STDOUT
#SBATCH -e $output_dir/slurm_output/slurm.gatk_subtract.JOBNAME.%N.%j.err # STDERR
#SBATCH -J gatk_subtract_JOBNAME
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill\@jic.ac.uk # send-to address
SLURM


 my $tmp_file = "$output_dir/tmp/gatk_subtract_08_04_2016.$output";

  open (SLURM, ">$tmp_file") or die "Couldn't open temp file\n";
  $SLURM_header =~ s/JOBNAME/$output/g;
  print SLURM "$SLURM_header\n\n";
  print SLURM "\ncd $output_dir/\n";

# source programmes
print SLURM "source GATK-3.5.0 \n";
#  print SLURM "source picard-1.134\n";

# first time only need to sort the vcf from ensembl
#  print SLURM "srun picard SortVcf I=$path/exome_capture_analysis/inter-homoeologous_variants_ensembl.vcf O=$path/exome_capture_analysis/inter-homoeologous_variants_ensembl.sorted.vcf SEQUENCE_DICTIONARY=$path/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.dict\n";

#combine the data 
print SLURM "srun gatk -T CombineVariants -R $ref -V:VCF $path/exome_capture_analysis/inter-homoeologous_variants_ensembl_replaced_ambig_var.sorted.vcf -V:$sample $sample".".MergeBam_merged_markdup_rm_2nd_time_var.flt.vcf -o inter_homoeologue_with_$sample"."_merged.vcf \n";

print SLURM "srun grep 'set=$sample' inter_homoeologue_with_$sample"."_merged.vcf > $sample.excl_inter_homoeologue_var.vcf\n"; 

  close SLURM;
#  system("sbatch $tmp_file");
#  unlink $tmp_file;


## need to close loop which goes through all of the directories in the list
	}
	    close(INPUT_FILE); 





















