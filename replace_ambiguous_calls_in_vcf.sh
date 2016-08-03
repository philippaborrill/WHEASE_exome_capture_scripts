#!/bin/bash
#
# SLURM batch script to launch replace ambiguous bases in vcf
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/replace_ambig_var.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bwa-aln/slurm_output/replace_ambig_var.%N.%j.err # STDERR
#SBATCH -J fasta_length
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis

# separate out header from the body of the vcf

#head -7 inter-homoeologous_variants_ensembl.vcf > header_inter_hom_var_ensembl.vcf

#sed -e '1,7d' inter-homoeologous_variants_ensembl.vcf > body_inter_hom_var_ensembl.vcf

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/scripts_used
perl replace_ambiguous_calls_in_vcf.pl

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/

cat header_inter_hom_var_ensembl.vcf body_inter_hom_var_ensembl_removed_ambig_var.vcf > inter-homoeologous_variants_ensembl_replaced_ambig_var.vcf

