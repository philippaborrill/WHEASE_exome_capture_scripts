#!/bin/bash
#
# SLURM batch script to launch bedtools 
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/bedtools_intersect.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/bedtools_intersect.%N.%j.err # STDERR
#SBATCH -J bedtools_intersect
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source bedtools-2.17.0

# select only the sections of the vcfs which are contained within "starch" genes
# -header means keep the header from file A and print it in the output file (necessary to have a properly formatted vcf output)
# -wa Write the original entry in A for each overlap
# -wb Write the original entry in B for each overlap
srun bedtools intersect -header -wa -wb -a samtools_sets1-8_merged_filtered_0.75_indiv_variant_positions_only_under2_hets_max_2_alleles.recode.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools_variants_in_starch_genes.vcf

srun grep -v '^#' samtools_variants_in_starch_genes.vcf > samtools_variants_in_starch_genes_no_header.vcf





