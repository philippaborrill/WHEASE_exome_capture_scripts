#!/bin/bash
#
# SLURM batch script to launch GATK variant filtering
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.err # STDERR
#SBATCH -J GATK_merge
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header/

source GATK-3.5.0

#combine the data keeping only variants found in 2 or more Cadenza samples
gatk -T ValidateVariants -R /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa -V:VCF variants_found_in_2_or_more_Cadenza_het_in_at_least_1_mutant.vcf

#gatk -T ValidateVariants -R /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa -V variants_found_in_2_or_more_Cadenza.vcf



