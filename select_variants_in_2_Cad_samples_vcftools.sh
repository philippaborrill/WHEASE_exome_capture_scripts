#!/bin/bash
#
# SLURM batch script to launch vcftools variant filtering
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.vcftools_filter.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.vcftools_filter.%N.%j.err # STDERR
#SBATCH -J vcftools_merge
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header/

source vcftools-0.1.12
# need to add location of Vcf.pm to @INC
export PERL5LIB=/nbi/software/testing/vcftools/0.1.12/src/vcftools_0.1.12/perl

#need to bgzip and tabix index the vcf files
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf > Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf > Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf > Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf > Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz

#count the number of variants found in each Cadenza sample or in multiple Cadenza samples
#vcf-compare Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz > vcftools_variants_found_in_Cadenza_common.vcf

# find the sites which are the same between 2+ Cadenza samples
vcf-isec -n +2 Cadenza0157.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0289.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0301.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz Cadenza0337.MergeBam.cleaned.markdup_rm_var.flt.vcf.gz > vcftools_variants_found_in_2_or_more_Cadenza.vcf

