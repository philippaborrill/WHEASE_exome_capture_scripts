#!/bin/bash
#
# SLURM batch script to launch samtools genotyping
#
#SBATCH -p nbi-long # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 120000 # memory pool for all cores
#SBATCH -t 60-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/freebayes_all.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/freebayes_all.%N.%j.err # STDERR
#SBATCH -J all_freebayes_variant
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source samtools-0.1.19

source freebayes-1.0.2

# --use-best-n-alleles 2 = only allow sites with up to 2 alleles (helps reduce memory usage)
# --min-alternate-count 3 = only allow sites which are supported by at least 3 reads (helps reduce memory usage)
# --min-mapping-quality 7 = only use reads with MAPQ>7
# --min-base-quality 20 = only use bases with quality > 20

freebayes -f /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa --use-best-n-alleles 2 --min-mapping-quality 7 --min-base-quality 20 1190004.MergeBam_merged_markdup_rm_2nd_time.bam 1190007.MergeBam_merged_markdup_rm_2nd_time.bam 1190023.MergeBam_merged_markdup_rm_2nd_time.bam 1190034.MergeBam_merged_markdup_rm_2nd_time.bam 1190081.MergeBam_merged_markdup_rm_2nd_time.bam 1190216.MergeBam_merged_markdup_rm_2nd_time.bam 1190218.MergeBam_merged_markdup_rm_2nd_time.bam 1190223.MergeBam_merged_markdup_rm_2nd_time.bam 1190238.MergeBam_merged_markdup_rm_2nd_time.bam 1190246.MergeBam_merged_markdup_rm_2nd_time.bam 1190273.MergeBam_merged_markdup_rm_2nd_time.bam 1190281.MergeBam_merged_markdup_rm_2nd_time.bam 1190291.MergeBam_merged_markdup_rm_2nd_time.bam 1190299.MergeBam_merged_markdup_rm_2nd_time.bam 1190300.MergeBam_merged_markdup_rm_2nd_time.bam 1190305.MergeBam_merged_markdup_rm_2nd_time.bam 1190308.MergeBam_merged_markdup_rm_2nd_time.bam 1190433.MergeBam_merged_markdup_rm_2nd_time.bam 1190444.MergeBam_merged_markdup_rm_2nd_time.bam 1190471.MergeBam_merged_markdup_rm_2nd_time.bam 1190496.MergeBam_merged_markdup_rm_2nd_time.bam 1190546.MergeBam_merged_markdup_rm_2nd_time.bam 1190560.MergeBam_merged_markdup_rm_2nd_time.bam 1190562.MergeBam_merged_markdup_rm_2nd_time.bam 1190566.MergeBam_merged_markdup_rm_2nd_time.bam 1190568.MergeBam_merged_markdup_rm_2nd_time.bam 1190580.MergeBam_merged_markdup_rm_2nd_time.bam 1190605.MergeBam_merged_markdup_rm_2nd_time.bam 1190629.MergeBam_merged_markdup_rm_2nd_time.bam 1190685.MergeBam_merged_markdup_rm_2nd_time.bam 1190694.MergeBam_merged_markdup_rm_2nd_time.bam 1190698.MergeBam_merged_markdup_rm_2nd_time.bam 1190700.MergeBam_merged_markdup_rm_2nd_time.bam 1190722.MergeBam_merged_markdup_rm_2nd_time.bam 1190732.MergeBam_merged_markdup_rm_2nd_time.bam 1190742.MergeBam_merged_markdup_rm_2nd_time.bam Cougar.MergeBam_merged_markdup_rm_2nd_time.bam Crusoe.MergeBam_merged_markdup_rm_2nd_time.bam Cubanita.MergeBam_merged_markdup_rm_2nd_time.bam Dickens.MergeBam_merged_markdup_rm_2nd_time.bam Gallant.MergeBam_merged_markdup_rm_2nd_time.bam Ice-breaker.MergeBam_merged_markdup_rm_2nd_time.bam Invicta.MergeBam_merged_markdup_rm_2nd_time.bam JB-Diego.MergeBam_merged_markdup_rm_2nd_time.bam KWS_Kielder.MergeBam_merged_markdup_rm_2nd_time.bam Myriad.MergeBam_merged_markdup_rm_2nd_time.bam Oakley.MergeBam_merged_markdup_rm_2nd_time.bam Panorama.MergeBam_merged_markdup_rm_2nd_time.bam Relay.MergeBam_merged_markdup_rm_2nd_time.bam RW41079.MergeBam_merged_markdup_rm_2nd_time.bam Santiago.MergeBam_merged_markdup_rm_2nd_time.bam Scout.MergeBam_merged_markdup_rm_2nd_time.bam Skyfall.MergeBam_merged_markdup_rm_2nd_time.bam Solstice.MergeBam_merged_markdup_rm_2nd_time.bam Sterling.MergeBam_merged_markdup_rm_2nd_time.bam Stigg.MergeBam_merged_markdup_rm_2nd_time.bam Weaver.MergeBam_merged_markdup_rm_2nd_time.bam Chinese_Spring_MergeBamAlignment.bam Avalon_MergeBamAlignment.bam Opata_MergeBamAlignment.bam PI245368_MergeBamAlignment.bam PI406517_MergeBamAlignment.bam  > freebayes_all_samples_together.vcf



