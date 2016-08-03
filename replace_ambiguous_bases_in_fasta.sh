#!/bin/bash
#
# SLURM batch script to launch parallel bedtools tasks
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sensitive/slurm_output/sortvcf.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sensitive/slurm_output/sortvcf.%N.%j.err # STDERR
#SBATCH -J replace_ambiguous_bases
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/

#The sed command replaces all non ATCG/atcg characters with 'N' on non-header lines while ignoring header lines. Read sed commands so:
#sed -CMD_LINE_OPTIONS '/<pattern_that_matches_line_to_process>/<operation>/<text_or_expression_to_be_replaced>/<new_text_or_expression>/<options>' INPUT_FILE
sed -e '/^[^>]/s/[^ATGCatgc]/N/g' Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome.fa > Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_replaced_ambig_bases.fa


