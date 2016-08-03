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

# 1st select only the sections of the vcfs which are contained within "starch" genes
# -header means keep the header from file A and print it in the output file (necessary to have a properly formatted vcf output)
# -wa Write the original entry in A for each overlap
# -wb Write the original entry in B for each overlap
srun bedtools intersect -header -wa -wb -a samtools.set1_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set1_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set2_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set2_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set3_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set3_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set4_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set4_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set5_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set5_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set6_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set6_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set7_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set7_in_starch_genes.vcf

srun bedtools intersect -header -wa -wb -a samtools.set8_MAPQ7.flt.vcf -b /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/starch_genes_genes_only.gtf  > samtools.set8_in_starch_genes.vcf

# 2nd use bcftools merge to combine the 8 sets of vcfs
source vcftools-0.1.12
# need to add location of Vcf.pm to @INC
export PERL5LIB=/nbi/software/testing/vcftools/0.1.12/src/vcftools_0.1.12/perl

#need to bgzip and tabix index the vcf files

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set1_in_starch_genes.vcf > samtools.set1_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set1_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set2_in_starch_genes.vcf > samtools.set2_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set2_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set3_in_starch_genes.vcf > samtools.set3_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set3_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set4_in_starch_genes.vcf > samtools.set4_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set4_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set5_in_starch_genes.vcf > samtools.set5_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set5_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set6_in_starch_genes.vcf > samtools.set6_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set6_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set7_in_starch_genes.vcf > samtools.set7_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set7_in_starch_genes.vcf.gz

srun /nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/bgzip -c samtools.set8_in_starch_genes.vcf > samtools.set8_in_starch_genes.vcf.gz
/nbi/software/testing/tabix/0.2.6/src/tabix-0.2.6/tabix -p vcf samtools.set8_in_starch_genes.vcf.gz


# merge the vcf files
srun vcf-merge samtools.set1_in_starch_genes.vcf.gz samtools.set2_in_starch_genes.vcf.gz samtools.set3_in_starch_genes.vcf.gz  samtools.set4_in_starch_genes.vcf.gz samtools.set5_in_starch_genes.vcf.gz samtools.set6_in_starch_genes.vcf.gz samtools.set7_in_starch_genes.vcf.gz samtools.set8_in_starch_genes.vcf.gz > samtools_sets1-8_in_starch_genes_merged_by_vcf-tools.vcf


# select only useful variants in this merged file
source jre-7.21

# (countHet() < 2) # only keep variants where there are fewer than 2 het samples across all individuals (i.e. 0 or 1 hets)
# isVariant( GEN[*] ) # only keep variants where at least 1 sample is variant (i.e. not reference allele)
# (DP >= 3) # only keep variants where the read depth is over 3

cat samtools_sets1-8_in_starch_genes_merged_by_vcf-tools.vcf | java -jar SnpSift.jar filter "( (countHet() < 2) & isVariant( GEN[*] ) & (DP >= 3) )" > samtools_sets1-8_in_starch_genes_merged_by_vcf-tools_filtered_1het_and_coverage3DP.vcf


