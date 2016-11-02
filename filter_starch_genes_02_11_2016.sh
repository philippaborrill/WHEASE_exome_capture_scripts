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

# use file which has already been filtered to just include WHEASE samples

# first only keep variants within starch genes # NB bed file must be 0 based (have done this 2/11/2016)
srun java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar intIdx freebayes_all_samples_together_whease_only.recode.vcf data_for_Cristobal_starch_genes/starch_gene_contig_positions.bed > freebayes_all_samples_together_whease_only_starch_gene_variants.vcf

# only keep variants with < 2 hets (get rid of inter-homoeologue variants)
srun cat freebayes_all_samples_together_whease_only_starch_gene_variants.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() < 2)" > freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets.vcf

# only keep sites with hom dp >= 3 or het dp >= 5
srun cat freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() > 0) && (DP >= 5) | (countHom() > 0) && (DP >= 3)" >  freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_homCov3_hetCov5.vcf

# only keep sites with 75 % of samples with genotype
srun vcftools --vcf freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_homCov3_hetCov5.vcf --out freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_homCov3_hetCov5_75perc_indiv_cov --max-missing 0.75  --recode --recode-INFO-all

# or just filter for low coverage hets (require >=2 min depth for alt allele in hets)
# only keep sites with het AO (alt allele depth) >= 2
srun cat freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() > 0) && (AO >= 2) | (countHom() > 0)" >  freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_hetAltCov2.vcf

# then filter for sites with 75 % with genotype
srun vcftools --vcf freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_hetAltCov2.vcf --out freebayes_all_samples_together_whease_only_starch_gene_variants_under_2_hets_hetAltCov2_75perc_indiv_cov --max-missing 0.75  --recode --recode-INFO-all




