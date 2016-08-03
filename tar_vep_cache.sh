#!/bin/bash
#
# SLURM batch script to launch samtools faidx
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.tar.%N.%j.out # STDOUT
#SBATCH -e /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/slurm.tar.%N.%j.err # STDERR
#SBATCH -J samtools_faidx
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/group-data/ifs/NBI/Research-Groups/Cristobal-Uauy/WHEASE/vep_cache

tar xfz triticum_aestivum_vep_30_IWGSC1.0+popseq.tar.gz
