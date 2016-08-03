#!/bin/bash
#
# SLURM batch script to launch samtools faidx
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.samtools_index_1190004.%N.%j.out # STDOUT
#SBATCH -e /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.samtools_index_1190004.%N.%j.err # STDERR
#SBATCH -J samtools_faidx
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

source samtools-0.1.19

cd /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/no_bam_header

samtools index 1190004_1_n5.cleaned.bam 1190004_1_n5.cleaned.bai

samtools index 1190004_2_n5.cleaned.bam 1190004_2_n5.cleaned.bai

cd /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header
samtools index 1190004_1.MergeBam.cleaned.bam 1190004_1.MergeBam.cleaned.bai
samtools index 1190004_1.MergeBam.cleaned.markdup_rm.bam 1190004_1.MergeBam.cleaned.markdup_rm.bai
samtools index 1190004_2.MergeBam.cleaned.bam 1190004_2.MergeBam.cleaned.bai
samtools index 1190004_2.MergeBam.cleaned.markdup_rm.bam 1190004_2.MergeBam.cleaned.markdup_rm.bai

samtools index 1190004.MergeBam.cleaned.markdup_rm.merged.bam 1190004.MergeBam.cleaned.markdup_rm.merged.bai
samtools index 1190004.MergeBam.cleaned.markdup_rm.merged_markdup_rm_2nd_time.bam 1190004.MergeBam.cleaned.markdup_rm.merged_markdup_rm_2nd_time.bai

