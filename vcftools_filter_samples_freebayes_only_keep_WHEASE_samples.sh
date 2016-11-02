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

# remove Hapmap samples
#srun vcftools --vcf freebayes_all_samples_together.vcf --remove-indv Chinese_Spring --remove-indv Avalon --remove-indv Opata --remove-indv PI245368 --remove-indv PI406517 --out freebayes_all_samples_together_whease_only --recode --recode-INFO-all

# alt 2nd only keeps sites with <2 hets but ignore read depth
#srun cat freebayes_all_samples_together_whease_only.recode.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHet() < 2)" > freebayes_all_samples_together_whease_only_under_2_hets.vcf

# for use with gatk combinevariants merged file
# --max-missing 0.75 # only keep sites where 0.75 (75 %) or more of the data is present (i.e. didn't have coverage in original file)
# --recode # make a vcf with only the filtered variants
# --recode-INFO-all # put all the INFO field into the output vcf (sometimes wouldn't make sense e.g. if you removed a sample so be cautious)

#srun vcftools --vcf freebayes_all_samples_together_whease_only_under_2_hets.vcf --out freebayes_all_samples_together_whease_only_under_2_hets_75perc_indiv_cov --max-missing 0.75  --recode --recode-INFO-all

# only keeps sites with >0 variants but ignore read depth
#srun cat freebayes_all_samples_together_whease_only_under_2_hets_75perc_indiv_cov.recode.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countVariant() > 0)" > freebayes_all_samples_together_whease_only_under_2_hets_75perc_indiv_variant_sites.vcf

# only keeps sites with >0 hom but ignore read depth
srun cat freebayes_all_samples_together_whease_only_under_2_hets_75perc_indiv_cov.recode.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countHom() > 0)" > freebayes_all_samples_together_whease_only_under_2_hets_75perc_indiv_over_1_hom.vcf

