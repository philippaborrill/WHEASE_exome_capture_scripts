# Aim is to re-format VCF file for use with "popart" haplotype software
# want to also generate a simple tab delimited file for Cristobal to work with in excel
# will make a separate tab delimited file for each gene in 2 versions - for popart and for excel
# 03.11.2016

# sometimes 1 gene is split into two gene models in IWGSC assembly. In these cases I will concatenate the SNPs from the different contigs together 
# which actually belong to the same gene since the haplotype should still be correct

#### with indels ####

# set directory
setwd("Y:\\WHEASE\\exome_capture_analysis\\bowtie2_very_sens_replaced_ambig")

vcf_file <- read.table(file= "starch_gene_variants_filtered_recoded.txt", header = T, sep= "\t")
head(vcf_file)
colnames(vcf_file)

#remove unnecessary columns
vcf_file1 <- vcf_file[,c(-7,-8, -9, -10, -11, -12, -13)]

head(vcf_file1)
is.data.frame((vcf_file1))

head(vcf_file1)
colnames(vcf_file1)

# re-order according to Cristobal's list
vcf_file2 <- cbind(vcf_file1[,c(1:6, 43,44,47,49,50,53,54,57,59,51,56,62,52,45,46,55,48,58,60,61,63,64,7:42 )])

dim(vcf_file1)
dim(vcf_file2)
colnames(vcf_file2)

# remove gene name (keep gene name with chr arm)
vcf_file2 <- vcf_file2[,-5]
dim(vcf_file2)
colnames(vcf_file2)

# rename RW41079 to Solace
colnames(vcf_file2) <- c(colnames(vcf_file2)[1:12], "Solace", colnames(vcf_file2)[14:63])
colnames(vcf_file2)

# remove X from beginning of Watkins IDs
colnames(vcf_file2) <- gsub("X","",colnames(vcf_file2))

# now want to separate each gene into separate data frame

setwd("Y:\\WHEASE\\exome_capture_analysis\\bowtie2_very_sens_replaced_ambig\\data_for_Cristobal_starch_genes\\output_for_cristobal_with_indels")
list_of_genes <- as.character(unique(vcf_file2$gene.name.with.chr.arm))
list_of_genes
length(list_of_genes)

list_of_genes[1]

#i=1

for (i in 1:length(list_of_genes)) {
  new_data <- vcf_file2[which(vcf_file2$gene.name.with.chr.arm == list_of_genes[i]),]
  head(new_data)
  dim(new_data)
  colnames(new_data) <- gsub("X","",colnames(new_data))
  t_new_data <- t(new_data)
  write.table(t_new_data, file=paste0(list_of_genes[i],".tab.txt"), sep ="\t",col.names = F)
  num_var <- dim(t_new_data)[2]
  print(num_var)
  
  fileConn<-file(paste0(list_of_genes[i],".popart.txt"))
  
  writeLines(c("#NEXUS","BEGIN TAXA;","DIMENSIONS NTAX=58;","TAXLABELS","Chinese_Spring","Cougar","Dickens","Ice_breaker","Invicta","Myriad","Oakley","Solace","Scout","JB_Diego","Relay","Sterling","KWS_Kielder","Crusoe","Cubanita","Panorama","Gallant","Santiago","Skyfall","Solstice","Stigg","Weaver","1190004","1190007","1190023","1190034","1190081","1190216","1190218","1190223","1190238","1190246","1190273","1190281","1190291","1190299","1190300","1190305","1190308","1190433","1190444","1190471","1190496","1190546","1190560","1190562","1190566","1190568","1190580","1190605","1190629","1190685","1190694","1190698","1190700","1190722","1190732","1190742",";","END;","","BEGIN CHARACTERS;",paste0("DIMENSIONS NCHAR=",num_var,";"),"FORMAT DATATYPE=DNA MISSING=. GAP=- ;","MATRIX",""),fileConn)
  close(fileConn)
  
  write.table(t_new_data[6:63,], file=paste0(list_of_genes[i],".popart.txt"), sep ="\t",col.names = F, append=T, quote=F)
  
  
  cat(c("","",";","END;","","BEGIN TRAITS;","  Dimensions NTRAITS=2;","  Format labels=yes missing=? separator=tab;","  TraitLabels Landrace	Variety;","  Matrix","Chinese_Spring	1	0","Cougar	0	1","Dickens	0	1","Ice_breaker	0	1","Invicta	0	1","Myriad	0	1","Oakley	0	1","Solace	0	1","Scout	0	1","JB_Diego	0	1","Relay	0	1","Sterling	0	1","KWS_Kielder	0	1","Crusoe	0	1","Cubanita	0	1","Panorama	0	1","Gallant	0	1","Santiago	0	1","Skyfall	0	1","Solstice	0	1","Stigg	0	1","Weaver	0	1","1190004	1	0","1190007	1	0","1190023	1	0","1190034	1	0","1190081	1	0","1190216	1	0","1190218	1	0","1190223	1	0","1190238	1	0","1190246	1	0","1190273	1	0","1190281	1	0","1190291	1	0","1190299	1	0","1190300	1	0","1190305	1	0","1190308	1	0","1190433	1	0","1190444	1	0","1190471	1	0","1190496	1	0","1190546	1	0","1190560	1	0","1190562	1	0","1190566	1	0","1190568	1	0","1190580	1	0","1190605	1	0","1190629	1	0","1190685	1	0","1190694	1	0","1190698	1	0","1190700	1	0","1190722	1	0","1190732	1	0","1190742	1	0","","",";","","END;"),
      file= paste0(list_of_genes[i],".popart.txt"),sep = "\n", append=T)
  
 
  }


##### without indels #####

# set directory
setwd("Y:\\WHEASE\\exome_capture_analysis\\bowtie2_very_sens_replaced_ambig")

vcf_file <- read.table(file= "starch_gene_variants_filtered_recoded_no_indels.txt", header = T, sep= "\t")
head(vcf_file)
colnames(vcf_file)

#remove unnecessary columns
vcf_file1 <- vcf_file[,c(-7,-8, -9, -10, -11, -12, -13)]

head(vcf_file1)
is.data.frame((vcf_file1))

head(vcf_file1)
colnames(vcf_file1)

# re-order according to Cristobal's list
vcf_file2 <- cbind(vcf_file1[,c(1:6, 43,44,47,49,50,53,54,57,59,51,56,62,52,45,46,55,48,58,60,61,63,64,7:42 )])

dim(vcf_file1)
dim(vcf_file2)
colnames(vcf_file2)

# remove gene name (keep gene name with chr arm)
vcf_file2 <- vcf_file2[,-5]
dim(vcf_file2)
colnames(vcf_file2)

# rename RW41079 to Solace
colnames(vcf_file2) <- c(colnames(vcf_file2)[1:12], "Solace", colnames(vcf_file2)[14:63])
colnames(vcf_file2)

# remove X from beginning of Watkins IDs
colnames(vcf_file2) <- gsub("X","",colnames(vcf_file2))

# now want to separate each gene into separate data frame

setwd("Y:\\WHEASE\\exome_capture_analysis\\bowtie2_very_sens_replaced_ambig\\data_for_Cristobal_starch_genes\\output_for_cristobal_without_indels")
list_of_genes <- as.character(unique(vcf_file2$gene.name.with.chr.arm))
list_of_genes
length(list_of_genes)

list_of_genes[1]

#i=1

for (i in 1:length(list_of_genes)) {
  new_data <- vcf_file2[which(vcf_file2$gene.name.with.chr.arm == list_of_genes[i]),]
  head(new_data)
  dim(new_data)
  colnames(new_data) <- gsub("X","",colnames(new_data))
  t_new_data <- t(new_data)
  write.table(t_new_data, file=paste0(list_of_genes[i],".tab.txt"), sep ="\t",col.names = F)
  num_var <- dim(t_new_data)[2]
  print(num_var)
  
  fileConn<-file(paste0(list_of_genes[i],".popart.txt"))
  
  writeLines(c("#NEXUS","BEGIN TAXA;","DIMENSIONS NTAX=58;","TAXLABELS","Chinese_Spring","Cougar","Dickens","Ice_breaker","Invicta","Myriad","Oakley","Solace","Scout","JB_Diego","Relay","Sterling","KWS_Kielder","Crusoe","Cubanita","Panorama","Gallant","Santiago","Skyfall","Solstice","Stigg","Weaver","1190004","1190007","1190023","1190034","1190081","1190216","1190218","1190223","1190238","1190246","1190273","1190281","1190291","1190299","1190300","1190305","1190308","1190433","1190444","1190471","1190496","1190546","1190560","1190562","1190566","1190568","1190580","1190605","1190629","1190685","1190694","1190698","1190700","1190722","1190732","1190742",";","END;","","BEGIN CHARACTERS;",paste0("DIMENSIONS NCHAR=",num_var,";"),"FORMAT DATATYPE=DNA MISSING=. GAP=- ;","MATRIX",""),fileConn)
  close(fileConn)
  
  write.table(t_new_data[6:63,], file=paste0(list_of_genes[i],".popart.txt"), sep ="\t",col.names = F, append=T, quote=F)
  
  
  cat(c("","",";","END;","","BEGIN TRAITS;","  Dimensions NTRAITS=2;","  Format labels=yes missing=? separator=tab;","  TraitLabels Landrace	Variety;","  Matrix","Chinese_Spring	1	0","Cougar	0	1","Dickens	0	1","Ice_breaker	0	1","Invicta	0	1","Myriad	0	1","Oakley	0	1","Solace	0	1","Scout	0	1","JB_Diego	0	1","Relay	0	1","Sterling	0	1","KWS_Kielder	0	1","Crusoe	0	1","Cubanita	0	1","Panorama	0	1","Gallant	0	1","Santiago	0	1","Skyfall	0	1","Solstice	0	1","Stigg	0	1","Weaver	0	1","1190004	1	0","1190007	1	0","1190023	1	0","1190034	1	0","1190081	1	0","1190216	1	0","1190218	1	0","1190223	1	0","1190238	1	0","1190246	1	0","1190273	1	0","1190281	1	0","1190291	1	0","1190299	1	0","1190300	1	0","1190305	1	0","1190308	1	0","1190433	1	0","1190444	1	0","1190471	1	0","1190496	1	0","1190546	1	0","1190560	1	0","1190562	1	0","1190566	1	0","1190568	1	0","1190580	1	0","1190605	1	0","1190629	1	0","1190685	1	0","1190694	1	0","1190698	1	0","1190700	1	0","1190722	1	0","1190732	1	0","1190742	1	0","","",";","","END;"),
      file= paste0(list_of_genes[i],".popart.txt"),sep = "\n", append=T)
  
  
}
