#!/bin/bash
#
# SLURM batch script to launch GATK variant filtering
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.err # STDERR
#SBATCH -J GATK_merge
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header/

source GATK-3.5.0

#combine the data keeping only variants found in 2 or more Cadenza samples
gatk -T CombineVariants -R /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa -minN 2 -V:Cadenza0157 Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf -V:Cadenza0289 Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf -V:Cadenza0301 Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf -V:Cadenza0337 Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf -o variants_found_in_2_or_more_Cadenza.vcf



