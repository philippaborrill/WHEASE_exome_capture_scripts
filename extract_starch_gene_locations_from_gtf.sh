## NB this is not actually a script to submit to slurm I just run it on the head node.

# The aim is to use grep + awk to extract the gene locations of only starch genes from the gtf of all genes

# need inputs of starch_gene_list.txt (list of all starch-related genes, one per line) and gtf of all genes 
# - will pad this file 300 bp upstream and downstream of each gene and use that to select out only variants in these regions from the vcfs
 cd /nbi/Research-Groups/NBI/Cristobal-Uauy/WHEASE
 grep -f starch_gene_list.txt Triticum_aestivum.IWGSC1.0+popseq.30.sorted.gtf | awk '$3=="gene" {print}' > starch_genes_genes_only.gtf

# now want to not only get genes but also CDS and exon information - will use this file for VEP

 grep -f starch_gene_list.txt Triticum_aestivum.IWGSC1.0+popseq.30.sorted.gtf  > starch_genes_exon_structure.gtf
