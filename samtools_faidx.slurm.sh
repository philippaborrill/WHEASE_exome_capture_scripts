#!/bin/bash
#
# SLURM batch script to launch samtools faidx
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/slurm.samtools_faidx.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/slurm.samtools_faidx.%N.%j.err # STDERR
#SBATCH -J samtools_faidx
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/

#samtools faidx Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa

samtools faidx Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa
