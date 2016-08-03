#!/bin/bash
#
# SLURM batch script to launch parallel samtools tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/PB_collaborations/rht13_Wolfgang/analysis/TGAC_assembly_v1.30/bwa0.6.2/slurm_output/samtools_mpileup.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/PB_collaborations/rht13_Wolfgang/analysis/TGAC_assembly_v1.30/bwa0.6.2/slurm_output/samtools_mpileup.%N.%j.err # STDERR
#SBATCH -J freebayes
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/PB_collaborations/rht13_Wolfgang/analysis/TGAC_assembly_v1.30/bwa0.6.2/
source freebayes-1.0.2

freebayes -f /nbi/group-data/ifs/NBI/Cristobal-Uauy/RefSeq/TGAC_v1.30/Triticum_aestivum.TGACv1.30.dna_sm.genome.fa 120T_n5.sorted.markdup_rm.q20.bam 326T_n5.sorted.markdup_rm.q20.bam MagnifMutant_n5.sorted.markdup_rm.q20.bam MagnifWildtype_n5.sorted.markdup_rm.q20.bam  > 4_samples_together_freebayes_n5.sorted.markdup_rm.vcf 


