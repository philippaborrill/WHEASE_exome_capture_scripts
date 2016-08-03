#!/bin/bash
#
# SLURM batch script to launch bedtools slop
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/bedtools_intersect.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/bedtools_intersect.%N.%j.err # STDERR
#SBATCH -J bedtools_intersect
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header

source bedtools-2.17.0

bedtools intersect -wa -wb -a unique_to_1190722.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > 1190722_variants_in_starch_genes.vcf
