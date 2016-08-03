#!/bin/bash
#
# SLURM batch script to launch fasta names sizes
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/fasta_length.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/fasta_length.%N.%j.err # STDERR
#SBATCH -J fasta_length
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/

perl /usr/users/metbio/borrillp/fasta_names_sizes.pl Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa > Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_chrom_sizes.txt	
