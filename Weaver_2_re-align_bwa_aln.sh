#!/bin/bash
#
# SLURM batch script to launch bwa-aln
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.bwa_aln_Weaver_2_retry.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.bwa_aln_Weaver_2_retry.%N.%j.err # STDERR
#SBATCH -J bwa_aln_Weaver_2_retry
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_data_march_2016/PKG_ENQ-718_50_wheat_exomes_data_transfer//Sample_1471_LIB17624_LDI15083
source fastqc-0.10.1
source samtools-0.1.19
fastqc 1471_LIB17624_LDI15083_GATCAG_L007_R1.fastq.gz --outdir=/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//fastqc2
fastqc 1471_LIB17624_LDI15083_GATCAG_L007_R2.fastq.gz --outdir=/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//fastqc2
source bwa-0.7.12
bwa aln -t 64 -n 5 /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa 1471_LIB17624_LDI15083_GATCAG_L007_R1.fastq.gz > /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_bwa_R1_n5.sai
bwa aln -t 64 -n 5 /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa 1471_LIB17624_LDI15083_GATCAG_L007_R2.fastq.gz > /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_bwa_R2_n5.sai

bwa sampe /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_bwa_R1_n5.sai /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_bwa_R2_n5.sai 1471_LIB17624_LDI15083_GATCAG_L007_R1.fastq.gz 1471_LIB17624_LDI15083_GATCAG_L007_R2.fastq.gz > /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sam

samtools view -bS /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sam > /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.bam
samtools sort /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.bam /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sorted
samtools flagstat /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sorted.bam > /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sorted.flagstat.txt
samtools index /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sorted.bam /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sorted.bai
rm -f /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.sam
rm -f /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis//Weaver_2_n5.bam
