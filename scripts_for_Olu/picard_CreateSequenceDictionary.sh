#!/bin/bash
#
# SLURM batch script to launch parallel bedtools tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/create_seq_dict.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/create_seq_dict.%N.%j.err # STDERR
#SBATCH -J picard_create_sequence_dictionary
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/

source picard-1.134
picard CreateSequenceDictionary REFERENCE=Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa OUTPUT=Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.dict
