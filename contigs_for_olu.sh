#!/bin/bash
#
# SLURM batch script to launch count_filtered_variants
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/contigs_for_olu.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/contigs_for_olu.%N.%j.err # STDERR
#SBATCH -J contigs_for_olu
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


# 1st extract using grep the scaffolds which are still scaffolds (i.e. not incorporated into the pseudomolecule)
cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/data_for_Olu

#grep -f 4AL_gene_contigs.txt ../freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf > variants_in_4AL_SNPs_filtered_min_depth_3_covered_in_0.75_indiv_under_2_hets_max_2_alleles.vcf

#grep "CHROM" ../freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf > header.txt

#cat header.txt variants_in_4AL_SNPs_filtered_min_depth_3_covered_in_0.75_indiv_under_2_hets_max_2_alleles.vcf > variants_in_4AL_SNPs_filtered_min_depth_3_covered_in_0.75_indiv_under_2_hets_max_2_alleles_with_header.vcf

# 2nd use vcfilter to extract the variants which are within the scaffodls incorporated into pseudomolecules
vcftools --vcf ../freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf --out 4AL_variants_on_pseudomolecule --bed 4AL_gene_contigs_pseudomolecule_positions.bed --recode --recode-INFO-all

grep -v '^#'  4AL_variants_on_pseudomolecule.recode.vcf > 4AL_variants_on_pseudomolecule.recode_removed_header.vcf

cat variants_in_4AL_SNPs_filtered_min_depth_3_covered_in_0.75_indiv_under_2_hets_max_2_alleles_with_header.vcf 4AL_variants_on_pseudomolecule.recode_removed_header.vcf > combined_4AL_variants_on_scaffolds_and_on_pseudomolecule.vcf


