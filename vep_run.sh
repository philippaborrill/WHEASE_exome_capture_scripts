#!/bin/bash
#
# SLURM batch script to launch vep
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/vep.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/vep.%N.%j.err # STDERR
#SBATCH -J vep
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



## vep notes


# cache stored in:
#/nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/vep_cache

# need to tell vep the cache location when  you run the script

#--cache # tells vep to use a cache (not human default)
#--dir_cache /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/vep_cache #specify the cache directory to use
#--offline # enable offline mode
#--cache_version 30 # use a different version of the cache than the default assumed by VEP (which would be the same as the VEP number 81)

cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig/

source vep-81 variant_effect_predictor.pl
perl variant_effect_predictor.pl --cache --dir_cache /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/vep_cache --offline --cache_version 30 -i 


