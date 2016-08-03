#!/bin/bash
#
# SLURM batch script to launch bowtie2 index
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 60000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/gatk_combine_variants.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/gatk_combine_variants.%N.%j.err # STDERR
#SBATCH -J gatk_combine
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source GATK-3.5.0

gatk -T CombineVariants -R /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa --variant freebayes.set1_MAPQ7.flt.vcf --variant freebayes.set2_MAPQ7.flt.vcf --variant freebayes.set3_MAPQ7.vcf --variant freebayes.set4_MAPQ7.flt.vcf --variant freebayes.set5_MAPQ7.flt.vcf --variant freebayes.set6_MAPQ7.flt.vcf --variant freebayes.set7_MAPQ7.flt.vcf --variant freebayes.set8_MAPQ7.flt.vcf -o freebayes_sets1-8_merged.vcf -genotypeMergeOptions UNIQUIFY
