#!/bin/bash
#
# SLURM batch script to launch snpsift_filter_keep_1_hom
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

# only keeps sites with >0 variant (i.e. 1 genotype or more must be variant)
srun cat freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3.recode.vcf | java -jar /usr/users/metbio/borrillp/bin/snpEff/SnpSift.jar filter "(countVariant() > 0)" > freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode_DP3_min_1_variant.recode.vcf


