#!/bin/bash
#
# SLURM batch script to launch snpsift_filter_hets
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/snpsift.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/snpsift.%N.%j.err # STDERR
#SBATCH -J snpsift
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source jre-7.21

# (countHet() < 2) # only keep variants where there are fewer than 2 het samples across all individuals (i.e. 0 or 1 hets)
# isVariant( GEN[*] ) # only keep variants where at least 1 sample is variant (i.e. not reference allele): * means any 
# ( GEN[?].DP >= 3) # only keep variants where the read depth is over or equal to 3: ? means all


# DON'T USE: 2nd only keep sites with DP >=3
#srun cat samtools_sets1-8_merged_filtered_0.75_indiv_variant_positions_only.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "( GEN[?].DP >= 3)" > samtools_sets1-8_merged_filtered_0.75_indiv_variant_positions_only_3DP.vcf

# alt 2nd only keeps sites with <2 hets but ignore read depth
srun cat freebayes_all_samples_together_0.75_indiv_cov.recode.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() < 2)" > freebayes_all_samples_together_0.75_only_under2_hets.vcf

# only keep sites with 2 or fewer alleles
source vcftools-0.1.12
vcftools --vcf freebayes_all_samples_together_0.75_only_under2_hets.vcf --out freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles --max-alleles 2 --recode --recode-INFO-all

# 3rd keep only sites with <2 hets (i.e. 0 or 1 hets)
#srun cat samtools_sets1-8_merged_filtered_0.75_indiv_variant_positions_only_3DP.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() < 2)" > samtools_sets1-8_merged_filtered_0.75_indiv_variant_positions_only_3DP_under2_hets.vcf

