#!/bin/bash
#
# SLURM batch script to launch GATK variant filtering
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/slurm_output/slurm.GATK_filter.%N.%j.err # STDERR
#SBATCH -J GATK_filter
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bwa-aln/with_bam_header/

source GATK-3.5.0

#using the file which only contains variants found in 2+ Cadenza sample, want to select only heterozygous variants (i.e. mismappings)
# to do this have to look at genotype separately
# therefore for each genotype keep HET variants (this means some variants which are hom in some samples + het in others will be kept - think this is safer than requiring het mutation to be in all samples because some true het calls will be missing because of low coverage) 
gatk -T SelectVariants -R /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa --variant variants_found_in_2_or_more_Cadenza.vcf -select "(vc.getGenotype("Cadenza0157").isHet() || vc.getGenotype("Cadenza0289").isHet() || vc.getGenotype("Cadenza0301").isHet() || vc.getGenotype("Cadenza0337").isHet())" -o variants_found_in_2_or_more_Cadenza_keep_if_het_in_1_mutant.vcf



