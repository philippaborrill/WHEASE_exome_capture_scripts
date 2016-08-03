#!/bin/bash
#
# SLURM batch script to launch bwa-aln
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/gtf_to_bed.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/gtf_to_bed.%N.%j.err # STDERR
#SBATCH -J gtf_to_bed
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/
#grep -P "exon\t" Triticum_aestivum.IWGSC1.0+popseq.30.sorted.gtf > IWGSC_exons_only.gtf

/usr/users/metbio/borrillp/installs/bin/bedops gtf2bed IWGSC_exons_only.gtf > IWGSC_exons_only.bed
