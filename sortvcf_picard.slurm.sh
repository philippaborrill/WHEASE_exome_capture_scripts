#!/bin/bash
#
# SLURM batch script to launch parallel bedtools tasks
#
#SBATCH -p nbi-long # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 10-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2/slurm_output/sortvcf.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2/slurm_output/sortvcf.%N.%j.err # STDERR
#SBATCH -J sortvcf
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis

source picard-1.134

picard SortVcf I=inter-homoeologous_variants_ensembl_replaced_ambig_var.vcf O=inter-homoeologous_variants_ensembl_replaced_ambig_var.sorted.vcf SEQUENCE_DICTIONARY=/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.dict
