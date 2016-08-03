#!/bin/bash
#
# SLURM batch script to launch samtools index
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2/slurm_output/slurm.samtools_index_1190722.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2/slurm_output/slurm.samtools_index_1190722.%N.%j.err # STDERR
#SBATCH -J samtools_index
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

source samtools-0.1.19

#cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2

#samtools index 1190722.MergeBam_merged_markdup_rm_2nd_time.bam 1190722.MergeBam_merged_markdup_rm_2nd_time.bai

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sensitive/

samtools index 1190722.MergeBam_merged_markdup_rm_2nd_time.bam 1190722.MergeBam_merged_markdup_rm_2nd_time.bai 
