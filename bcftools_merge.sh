#!/bin/bash
#
# SLURM batch script to launch bcftools merge
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/bcftools_merge.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/bcftools_merge.%N.%j.err # STDERR
#SBATCH -J bcftools_merge
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source vcftools-0.1.12
# need to add location of Vcf.pm to @INC
export PERL5LIB=/nbi/software/testing/vcftools/0.1.12/src/vcftools_0.1.12/perl

#need to bgzip and tabix index the vcf files

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set1_MAPQ7.flt.vcf > samtools.set1_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set1_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set2_MAPQ7.flt.vcf > samtools.set2_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set2_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set3_MAPQ7.flt.vcf > samtools.set3_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set3_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set4_MAPQ7.flt.vcf > samtools.set4_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set4_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set5_MAPQ7.flt.vcf > samtools.set5_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set5_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set6_MAPQ7.flt.vcf > samtools.set6_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set6_MAPQ7.flt.vcf.gz

#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set7_MAPQ7.flt.vcf > samtools.set7_MAPQ7.flt.vcf.gz
#/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set7_MAPQ7.flt.vcf.gz

/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set8_MAPQ7.flt.vcf > samtools.set8_MAPQ7.flt.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set8_MAPQ7.flt.vcf.gz


#vcf-merge samtools.set1_MAPQ7.flt.vcf.gz samtools.set2_MAPQ7.flt.vcf.gz samtools.set3_MAPQ7.flt.vcf.gz  samtools.set4_MAPQ7.flt.vcf.gz samtools.set5_MAPQ7.flt.vcf.gz samtools.set6_MAPQ7.flt.vcf.gz samtools.set7_MAPQ7.flt.vcf.gz samtools.set8_MAPQ7.flt.vcf.gz -O v -o samtools_sets1-8_merged_by_vcf-tools.vcf 
