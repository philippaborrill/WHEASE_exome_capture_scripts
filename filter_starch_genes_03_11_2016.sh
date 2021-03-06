#!/bin/bash
#
# SLURM batch script to launch bowtie2 index
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 100000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/vcftools_filter.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/vcftools_filter.%N.%j.err # STDERR
#SBATCH -J vcftools_filter
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source vcftools-0.1.12
source jre-7.21

sed 's/0\/1/.\/./g' < freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_dp3_0.75_perc_variant_sites.vcf > freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_dp3_0.75_perc_variant_sites_het_as_missing.vcf

# only keeps sites with >0 variants
srun cat freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_dp3_0.75_perc_variant_sites_het_as_missing.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countVariant() > 0)" > freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_dp3_0.75_perc_variant_sites_het_as_missing_variant_sites.vcf



