#!/bin/bash
#
# SLURM batch script to extract promoter sequences
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 10000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//promoter_sequences_for_karunesh/slurm_output/promoters_for_karunesh.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//promoter_sequences_for_karunesh/slurm_output/promoters_for_karunesh.%N.%j.err # STDERR
#SBATCH -J promoter_sequences_for_karunesh
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address


cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/promoter_sequences_for_karunesh

# had to run the grep step on the head node becuase for some reason it wouldn't do it here
#srun grep 'exon_number "1"' /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.gtf | grep "CDS" > positions_of_all_first_exons.gtf

#wc -l positions_of_all_first_exons.gtf > number_of_lines_in_1st_exon_gtf_file.txt

source bedtools-2.17.0 
# -s for bedtools means that it will take strand into consideration

#srun bedtools flank -s -i positions_of_all_first_exons.gtf -g /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_chrom_sizes.txt -l 1000 -r 0 > 1000bp_left_of_ATG.bed

#srun bedtools flank -s -i positions_of_all_first_exons.gtf -g /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/Triticum_aestivum.IWGSC1.0+popseq.30.dna_sm.genome_chrom_sizes.txt -l 500 -r 0 > 500bp_left_of_ATG.bed

#cd promoter_sequences_for_karunesh

#wc -l 1000bp_left_of_ATG.bed > number_of_lines_in_1000bp_upstream_bed.txt
#wc -l 500bp_left_of_ATG.bed > number_of_lines_in_500bp_upstream_bed.txt

srun perl /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/scripts_used/bed_to_fa.pl
