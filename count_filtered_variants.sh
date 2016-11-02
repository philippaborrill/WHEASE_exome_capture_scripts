#!/bin/bash
#
# SLURM batch script to launch count_filtered_variants
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/count_variants.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/count_variants.%N.%j.err # STDERR
#SBATCH -J count_variants
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

#echo freebayes_all_samples_together_0.75_indiv_cov.recode.vcf
#grep -v '^#' freebayes_all_samples_together_0.75_indiv_cov.recode.vcf | wc -l

#echo freebayes_all_samples_together_0.75_only_under2_hets.vcf
#grep -v '^#' freebayes_all_samples_together_0.75_only_under2_hets.vcf | wc -l

#echo freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode.vcf
#grep -v '^#' freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode.vcf | wc -l

#echo freebayes_all_samples_together_0.65_indiv_cov.recode.vcf
#grep -v '^#' freebayes_all_samples_together_0.65_indiv_cov.recode.vcf | wc -l

#echo freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf
#grep -v '^#' freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf | wc -l

#echo freebayes_all_samples_together_only_under2_hets.vcf
#grep -v '^#' freebayes_all_samples_together_only_under2_hets.vcf | wc -l


#echo freebayes_all_samples_together_only_under2_hets_max_2_alleles.recode.vcf
#grep -v '^#' freebayes_all_samples_together_only_under2_hets_max_2_alleles.recode.vcf | wc -l

echo freebayes_all_samples_together_whease_only.recode.vcf
grep -v '^#' freebayes_all_samples_together_whease_only.recode.vcf | wc -l

