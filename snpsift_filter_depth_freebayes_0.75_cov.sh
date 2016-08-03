#!/bin/bash
#
# SLURM batch script to launch snpsift_filter_hets
#
#SBATCH -p nbi-medium # partition (queue)
#SBATCH -N 1 # number of nodes
#SBATCH -n 1 # number of cores
#SBATCH --mem 30000 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH -o /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/snpsift.%N.%j.out # STDOUT
#SBATCH -e /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE//exome_capture_analysis/bowtie2_very_sens_replaced_ambig/slurm_output/snpsift.%N.%j.err # STDERR
#SBATCH -J snpsift
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=philippa.borrill@jic.ac.uk # send-to address



cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE/exome_capture_analysis/bowtie2_very_sens_replaced_ambig

source jre-7.21

# now want to only keep genotypes which have a read depth >= 3
# solution from https://www.biostars.org/p/124032/ 
# need to print 


#cat freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode.vcf | java -jar SnpSift.jar filter  `seq 1 62 | awk '{ printf("%s (GEN[%d].DP>2) ",(NR==1?"":" & "), $1);}'`

cat freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles.recode.vcf | java -jar SnpSift.jar filter "(GEN[0].DP>2) & (GEN[1].DP>2) & (GEN[2].DP>2) & (GEN[3].DP>2) & (GEN[4].DP>2) & (GEN[5].DP>2) & (GEN[6].DP>2) & (GEN[7].DP>2) & (GEN[8].DP>2) & (GEN[9].DP>2) & (GEN[10].DP>2) & (GEN[11].DP>2) & (GEN[12].DP>2) & (GEN[13].DP>2) & (GEN[14].DP>2) & (GEN[15].DP>2) & (GEN[16].DP>2) & (GEN[17].DP>2) & (GEN[18].DP>2) & (GEN[19].DP>2) & (GEN[20].DP>2) & (GEN[21].DP>2) & (GEN[22].DP>2) & (GEN[23].DP>2) & (GEN[24].DP>2) & (GEN[25].DP>2) & (GEN[26].DP>2) & (GEN[27].DP>2) & (GEN[28].DP>2) & (GEN[29].DP>2) & (GEN[30].DP>2) & (GEN[31].DP>2) & (GEN[32].DP>2) & (GEN[33].DP>2) & (GEN[34].DP>2) & (GEN[35].DP>2) & (GEN[36].DP>2) & (GEN[37].DP>2) & (GEN[38].DP>2) & (GEN[39].DP>2) & (GEN[40].DP>2) & (GEN[41].DP>2) & (GEN[42].DP>2) & (GEN[43].DP>2) & (GEN[44].DP>2) & (GEN[45].DP>2) & (GEN[46].DP>2) & (GEN[47].DP>2) & (GEN[48].DP>2) & (GEN[49].DP>2) & (GEN[50].DP>2) & (GEN[51].DP>2) & (GEN[52].DP>2) & (GEN[53].DP>2) & (GEN[54].DP>2) & (GEN[55].DP>2) & (GEN[56].DP>2) & (GEN[57].DP>2) & (GEN[58].DP>2) & (GEN[59].DP>2) & (GEN[60].DP>2) & (GEN[61].DP>2)" > freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles_DP3.vcf


# because this will mean some genotypes now have missing data need to re-filter to make sure I have 75 % of samples covered

source vcftools-0.1.12
# for use with gatk combinevariants merged file

# --max-missing 0.75 # only keep sites where 0.75 (75 %) or more of the data is present (i.e. didn't have coverage in original file)
# --recode # make a vcf with only the filtered variants
# --recode-INFO-all # put all the INFO field into the output vcf (sometimes wouldn't make sense e.g. if you removed a sample so be cautious)

vcftools --vcf freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles_DP3.vcf --out freebayes_all_samples_together_0.75_only_under2_hets_max_2_alleles_DP3_really_0.75 --max-missing 0.75  --recode --recode-INFO-all

