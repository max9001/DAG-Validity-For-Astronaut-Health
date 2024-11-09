library(bnlearn)
library(psych)
library(Rgraphviz)

# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Dubee / Alwood 
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

#read in file
alwood <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Dubee/LSDS-15_microCT_alwoodTRANSFORMED.csv")

print(colnames(alwood))
print(alwood)


## Alwood
alwood <- alwood[11:37,c(3:6,9)]
alwood$expose <- ifelse(alwood$Factor.Value=="Flight",1,0)
names(alwood)[2:5] <- c("thick","sep","num","bvtv")

trab <- pca(r=alwood[,c("sep","num")],nfactors=1,scores = T)
mass <- pca(r=alwood[,c("thick","bvtv")],nfactors=1,scores=T)

alwood$trab <- as.vector(trab$scores)
alwood$mass <- as.vector(mass$scores)

alwood <- alwood[,c("expose","trab","mass")]

rm(list=c("trab","mass"))

print(alwood)


dag_alwood <- pc.stable(alwood)
cor_alwood <- cor(alwood)
print(round(cor_alwood, 2))
c_dag_alwood <- cextend(dag_alwood)
graphviz.plot(dag_alwood)
graphviz.plot(c_dag_alwood)


# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Keune 2015 / GLDS
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

glds <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Keune 2015/FIX-GLDS-351.csv", header=T, stringsAsFactors=F)

glds$expose <- ifelse(glds$Teatment=="Ground Control",0,1)
glds<- glds[7:30,c(5:7,11,13,16:19,22:25)] 

print(glds)
print(unique(glds$expose))

# Make component variables
mass      <- pca(r=glds[,c("DXA_BMC_mg","DXA_BMD_mg_per_mmsq")],nfactors=1,scores = T)
trab_meta <- pca(r=glds[,c("metaphysis_canc_Tb_Sp_micrometer","metaphysis_canc_Tb_N_1per_mm")],nfactors=1,scores = T)
trab_epiph <- pca(r=glds[,c("epiphysis_canc_Tb_Sp_micrometer","epiphysis_canc_Tb_N_1per_mm")],nfactors=1,scores = T)

glds$mass <- as.vector(mass$scores)
glds$trab_meta <- as.vector(trab_meta$scores)
glds$trab_epiph <- as.vector(trab_epiph$scores)

# Standardize site-specific/single variable mass measures
print(names(glds)[5] )
names(glds)[5] <- "mass_meta"
glds$mass_meta <- scale(glds$mass_meta)

names(glds)[9] <- "mass_epiph"
glds$mass_epiph <- scale(glds$mass_epiph)

# Final dataset
glds <- glds[,c("expose","mass","mass_meta","mass_epiph","trab_meta","trab_epiph")]

rm(list=c("mass","trab_epiph","trab_meta"))

print(dim(glds))

print(glds)



glds_meta <- glds
glds_meta <- subset(glds_meta, select = -c(mass_epiph, trab_epiph))
print(glds_meta)

glds_epiph <- glds
glds_epiph <- subset(glds_epiph, select = -c(mass_meta, trab_meta))
print(glds_epiph)

# ----------------------------

# glds <- pc.stable(dag_glds)
# dag_glds <- cextend(dag_glds)
# graphviz.plot(dag_glds)
# 
# print(glds_meta)

dag_glds_meta <- pc.stable(glds_meta)
c_dag_glds_meta <- cextend(dag_glds_meta)
graphviz.plot(layout = "circo", dag_glds_meta)
graphviz.plot(layout = "circo", c_dag_glds_meta)

dag_glds_epiph <- pc.stable(glds_epiph)
c_dag_glds_epiph <- cextend(dag_glds_epiph)
graphviz.plot(layout = "circo", dag_glds_epiph)
graphviz.plot(layout = "circo", c_dag_glds_epiph)

cor_glds_epiph <- cor(glds_epiph)
print(round(cor_glds_epiph, 2))

cor_glds_meta <- cor(glds_meta)
print(round(cor_glds_meta, 2))

# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Keune 2016 / Turner
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

#read in file
turner <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Keune 2016/LSDS-30_histomorphometry_turnerTRANSFORMED.csv", header=T, stringsAsFactors=F)
turner <- turner[,c(1,3:9)] 
turner$expose <- ifelse(turner$Spaceflight=="Space Flight",1,0)
names(turner)[3:8] <- c("mass","labellength","cont_bf","ceased_bf","MAR","osteoc_per") 


print(colnames(turner))


# Create measures
resorp <- pca(r=turner[,c("labellength","osteoc_per")],nfactors=1,scores=T)
form   <- pca(r=turner[,c("ceased_bf","MAR")],nfactors=1,scores=T)

turner$resorp <- as.vector(resorp$scores)
turner$form   <- as.vector(form$scores)*-1  ## form loads "backwards"; multiply by -1 to fix
turner$mass   <- scale(turner$mass)

turner <- turner[,c(9,3,10:11)]
rm(list=c("form","resorp"))

dag_turner <- pc.stable(turner)
cor_turner <- cor(turner)
print(round(cor_turner, 2))
c_dag_turner <- cextend(dag_turner)
graphviz.plot(layout = "circo", dag_turner)
graphviz.plot(layout = "circo", c_dag_turner)


# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Ko 2020 pt1 / pt2 / other
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――


## Ko
nastring <- c("           *","epiphysis broken")  # things we want R to read as NA

# Read raw files
ko1 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (other)/LSDS-40_Bone_Biomechanical_LDSD-40_biomechanical_KoTRANSFORMED.csv",  header=T, stringsAsFactors=F)
ko2 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (other)/LSDS-40_histomorphometry_LSDS-40_histomorphometry_KoTRANSFORMED.csv", header=T, stringsAsFactors=F,na.strings=nastring)
ko3 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (pt2)/LSDS-40_microCT_LSDS-40_microCT_KoTRANSFORMED.csv",                   header=T, stringsAsFactors=F,na.strings=nastring)
ko4 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (pt1)/LSDS-41_peripheral_quantitative_computed_tomography_pQCT_LSDS-41_pQCT_KoTRANSFORMED.csv", header=T, stringsAsFactors=F)

# Subest to needed columns/rows
ko1 <- ko1[,c(1,3:4,8:10)]
ko2 <- ko2[!(is.na(ko2$Source.Name)),c(1,7:11)]
ko3 <- ko3[,c(1,10,13:17)]
ko4 <- ko4[,c(1,4:7)]

print(ko1)
print(ko2)
print(ko3)
print(ko4)

# Rename columns
names(ko1) <- c("ID","PWB","duration","stiffness","load.max","load.fail")
names(ko2) <- c("ID","OBSBS","OCSBS",'MSBS',"MAR","BFRBS")
names(ko3) <- c("ID","BVTV","trab.num","trab.thick","trab.sep","BMD","cort.thick")
names(ko4) <- c("ID","BMD0","BMD1","BMD2","BMD4")

# create indicators of source file
ko1$k1 <- 1
ko2$k2 <- 1
ko3$k3 <- 1
ko4$k4 <- 1

# Merge files
ko12   <- merge(ko1,ko2,by="ID",all.x=T,all.y=T)
ko123  <- merge(ko12,ko3,by="ID",all=T)
ko1234 <- merge(ko123,ko4,by="ID",all=T) 

# Fill in missing indicators with 0
ko1234$k1[is.na(ko12$k1)] <-0
ko1234$k2[is.na(ko12$k2)] <-0
ko1234$k3[is.na(ko12$k3)] <-0
ko1234$k4[is.na(ko12$k4)] <-0

# Keep only needed rows
ko <- ko1234[!(is.na(ko1234$stiffness)),]
ko$unload    <- 0*(ko$PWB=='PWB100')+30*(ko$PWB=="PWB70")+60*(ko$PWB=="PWB40")+80*(ko$PWB =="PWB20")
ko$dur   <- 7*(ko$duration=='1wk')+14*(ko$duration=='2wk')+28*(ko$duration=='4wk')
ko <- ko[,c('BVTV','BMD','trab.sep','trab.num','MSBS','OCSBS','BFRBS','load.max','load.fail','unload','dur')]

# Convert every column in 'ko' to numeric using sapply
ko <- as.data.frame(sapply(ko, as.numeric))

print(colnames(ko))


mass <- pca(r=ko[,c("BVTV","BMD")], nfactors = 1, scores = T)
trab <- pca(r=ko[,c("trab.sep","trab.num")], nfactors = 1, scores = T)
form   <- pca(r=ko[,c("MSBS","BFRBS")], nfactors = 1, scores = T)
stren <- pca(r=ko[,c("load.max","load.fail")], nfactors = 1, scores = T)

ko$mass <- as.vector(mass$scores[,1])
ko$trab <- as.vector(trab$scores[,1])
ko$stren <- as.vector(stren$scores[,1])
ko$expose <- ((ko$unload*ko$dur)-mean(ko$unload*ko$dur))/(sd(ko$unload*ko$dur))
ko$resorp <- scale(ko$OCSBS)
ko$form   <- as.vector(form$scores)


ko <- ko[,c("unload","dur","expose","mass","trab","stren","resorp","form")]

rm(list=c("mass","trab","form","stren"))

print(ko)
print(unique(ko$dur))

ko_subset <- ko[ko$dur == 28, ]
print(unique(ko_subset$dur))
print(ko_subset)

ko_subset$dur <- NULL


ko_subset <- ko_subset[ko_subset$unload == 60 | ko_subset$unload == 80 | ko_subset$unload == 0, ]
print(unique(ko_subset$unload))
print(ko_subset)

ko_2 <- ko
ko_2 <- subset(ko_2, select = -c(resorp, form))


# --------------------

dag_ko <- pc.stable(ko)
# c_dag_ko <- cextend(dag_ko)
graphviz.plot(dag_ko)

cor_ko_2 <- cor(ko)
print(round(cor_ko_2, 2))

dag_ko_2 <- pc.stable(ko_2)
graphviz.plot(dag_ko_2)
print(ko_2)

dag_ko_subset <- pc.stable(ko_subset)
c_dag_ko_subset <- cextend(dag_ko_subset)
graphviz.plot(dag_ko_subset)
graphviz.plot(c_dag_ko_subset)










# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# Ko 2020 pt1 / pt2 / other  attempt #2 9/20
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

## Ko
nastring <- c("           *","epiphysis broken")  # things we want R to read as NA

# Read raw files
ko1 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (other)/LSDS-40_Bone_Biomechanical_LDSD-40_biomechanical_KoTRANSFORMED.csv",  header=T, stringsAsFactors=F)
ko2 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (other)/LSDS-40_histomorphometry_LSDS-40_histomorphometry_KoTRANSFORMED.csv", header=T, stringsAsFactors=F,na.strings=nastring)
ko3 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (pt2)/LSDS-40_microCT_LSDS-40_microCT_KoTRANSFORMED.csv",                   header=T, stringsAsFactors=F,na.strings=nastring)
ko4 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/Ko 2020 (pt1)/LSDS-41_peripheral_quantitative_computed_tomography_pQCT_LSDS-41_pQCT_KoTRANSFORMED.csv", header=T, stringsAsFactors=F)

# Subest to needed columns/rows
ko1 <- ko1[,c(1,3:4,8:10)]
ko2 <- ko2[!(is.na(ko2$Source.Name)),c(1,7:11)]
ko3 <- ko3[,c(1,10,13:17)]
ko4 <- ko4[,c(1,4:7)]

# Rename columns
names(ko1) <- c("ID","PWB","duration","stiffness","load.max","load.fail")
names(ko2) <- c("ID","OBSBS","OCSBS",'MSBS',"MAR","BFRBS")
names(ko3) <- c("ID","BVTV","trab.num","trab.thick","trab.sep","BMD","cort.thick")
names(ko4) <- c("ID","BMD0","BMD1","BMD2","BMD4")

# create indicators of source file
ko1$k1 <- 1
ko2$k2 <- 1
ko3$k3 <- 1
ko4$k4 <- 1

# Merge files
ko12   <- merge(ko1,ko2,by="ID",all.x=T,all.y=T)
ko123  <- merge(ko12,ko3,by="ID",all=T)
ko1234 <- merge(ko123,ko4,by="ID",all=T) 

# Fill in missing indicators with 0
ko1234$k1[is.na(ko12$k1)] <-0
ko1234$k2[is.na(ko12$k2)] <-0
ko1234$k3[is.na(ko12$k3)] <-0
ko1234$k4[is.na(ko12$k4)] <-0

# Keep only needed rows
ko <- ko1234[!(is.na(ko1234$stiffness)),]

ko <- ko[!(ko$PWB %in% c("PWB70", "PWB40")), ]
# Rename the "PWB" column to "unload"
colnames(ko)[colnames(ko) == "PWB"] <- "unload"

# Assign values 0 for "PWB100" and 1 for "PWB20" in the "unload" column
ko$unload <- ifelse(ko$unload == "PWB100", 0, ifelse(ko$unload == "PWB20", 1, ko$unload))

ko <- ko[ko$duration != "1wk", ]
ko <- ko[ko$unload != "4wk", ]

ko_copy <- ko
ko_copy <- as.data.frame(sapply(ko_copy, as.numeric))

ko_natural <- ko_copy[, c("unload", "BVTV", "BMD", "trab.sep", "trab.num", "load.max", "load.fail")]

ko_synthetic <- ko_copy[, c("unload", "BVTV", "BMD", "trab.sep", "trab.num", "load.max", "load.fail")]

mass <- pca(r=ko_synthetic[,c("BVTV","BMD")], nfactors = 1, scores = T)
trab <- pca(r=ko_synthetic[,c("trab.sep","trab.num")], nfactors = 1, scores = T)
stren <- pca(r=ko_synthetic[,c("load.max","load.fail")], nfactors = 1, scores = T)

ko_synthetic$mass <- as.vector(mass$scores[,1])
ko_synthetic$trab <- as.vector(trab$scores[,1])
ko_synthetic$stren <- as.vector(stren$scores[,1])
ko_synthetic <- ko_synthetic[, c("unload", "mass", "trab", "stren")]




dag_natural <- pc.stable(ko_natural)
graphviz.plot(dag_natural, render = TRUE)

dag_synthetic <- pc.stable(ko_synthetic)
graphviz.plot(dag_synthetic, render = TRUE)





# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
# OSD-366
# ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――

#read in file
OSD366 <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/OSD-366/GLDS-366_GWAS_processed_associations_fix.csv")

for (i in 34:52) {
  new_name <- as.character(i - 33)
  colnames(OSD366)[i] <- new_name
}



colnames(OSD366) <- sub("FociPerGy", "Fpg", colnames(OSD366))
colnames(OSD366) <- sub("\\.MeV", "", colnames(OSD366))

subset_data <- OSD366[OSD366$"2" == 1, ]
print(dim(subset_data))
print(summary(subset_data$position.b38.))
# OSD366$position.b38. <- NULL

selected_columns <- OSD366[, c("Bgd_Si.350.n_4", "Bgd_Si.350.n_8", "Bgd_Si.350.n_24", "Bgd_Si.350.n_48")]
correlation_matrix <- cor(selected_columns)
print(correlation_matrix)

# print(OSD366)
# 
# Bgd_Si.350 <- pca(r = OSD366[,c("Bgd_Si.350.n_4", "Bgd_Si.350.n_8", "Bgd_Si.350.n_24", "Bgd_Si.350.n_48")], nfactors = 1, scores = TRUE)
# Fpg_Si.350 <- pca(r = OSD366[,c("Fpg_Si.350.n_4", "Fpg_Si.350.n_8", "Fpg_Si.350.n_24", "Fpg_Si.350.n_48")], nfactors = 1, scores = TRUE)
# Bgd_Ar.350 <- pca(r = OSD366[,c("Bgd_Ar.350.n_4", "Bgd_Ar.350.n_8", "Bgd_Ar.350.n_24", "Bgd_Ar.350.n_48")], nfactors = 1, scores = TRUE)
# Fpg_Ar.350 <- pca(r = OSD366[,c("Fpg_Ar.350.n_4", "Fpg_Ar.350.n_8", "Fpg_Ar.350.n_24", "Fpg_Ar.350.n_48")], nfactors = 1, scores = TRUE)
# Bgd_Fe.600 <- pca(r = OSD366[,c("Bgd_Fe.600.n_4", "Bgd_Fe.600.n_8", "Bgd_Fe.600.n_24", "Bgd_Fe.600.n_48")], nfactors = 1, scores = TRUE)
# Fpg_Fe.600 <- pca(r = OSD366[,c("Fpg_Fe.600.n_4", "Fpg_Fe.600.n_8", "Fpg_Fe.600.n_24", "Fpg_Fe.600.n_48")], nfactors = 1, scores = TRUE)
# Bgd_X.ray <- pca(r = OSD366[,c("Bgd_X.ray_4", "Bgd_X.ray_24", "Bgd_X.ray_48")], nfactors = 1, scores = TRUE)
# Fpg_X.ray <- pca(r = OSD366[,c("Fpg_X.ray_4", "Fpg_X.ray_24", "Fpg_X.ray_48")], nfactors = 1, scores = TRUE)
# 
# columns_to_remove <- c(
#   "Bgd_Si.350.n_4", "Bgd_Si.350.n_8", "Bgd_Si.350.n_24", "Bgd_Si.350.n_48",
#   "Fpg_Si.350.n_4", "Fpg_Si.350.n_8", "Fpg_Si.350.n_24", "Fpg_Si.350.n_48",
#   "Bgd_Ar.350.n_4", "Bgd_Ar.350.n_8", "Bgd_Ar.350.n_24", "Bgd_Ar.350.n_48",
#   "Fpg_Ar.350.n_4", "Fpg_Ar.350.n_8", "Fpg_Ar.350.n_24", "Fpg_Ar.350.n_48",
#   "Bgd_Fe.600.n_4", "Bgd_Fe.600.n_8", "Bgd_Fe.600.n_24", "Bgd_Fe.600.n_48",
#   "Fpg_Fe.600.n_4", "Fpg_Fe.600.n_8", "Fpg_Fe.600.n_24", "Fpg_Fe.600.n_48",
#   "Bgd_X.ray_4", "Bgd_X.ray_8", "Bgd_X.ray_24", "Bgd_X.ray_48",
#   "Fpg_X.ray_4", "Fpg_X.ray_8", "Fpg_X.ray_24", "Fpg_X.ray_48"
# )
# 
# OSD366 <- OSD366[, !(colnames(OSD366) %in% columns_to_remove)]
# 
# OSD366$Bgd_Si.350 <- as.vector(Bgd_Si.350$scores[,1])
# OSD366$Fpg_Si.350 <- as.vector(Fpg_Si.350$scores[, 1])
# OSD366$Bgd_Ar.350 <- as.vector(Bgd_Ar.350$scores[, 1])
# OSD366$Fpg_Ar.350 <- as.vector(Fpg_Ar.350$scores[, 1])
# OSD366$Bgd_Fe.600 <- as.vector(Bgd_Fe.600$scores[, 1])
# OSD366$Fpg_Fe.600 <- as.vector(Fpg_Fe.600$scores[, 1])
# OSD366$Bgd_X.ray <- as.vector(Bgd_X.ray$scores[, 1])
# OSD366$Fpg_X.ray <- as.vector(Fpg_X.ray$scores[, 1])

OSD366_numeric <- apply(OSD366, 2, as.numeric)
OSD366 <- as.data.frame(OSD366_numeric)



# Print the correlation matrix
print(correlation_matrix)


random_subset <- OSD366[sample(nrow(OSD366), size = 1000), ]
print(random_subset)


dag_OSD366 <- pc.stable(random_subset)
# graphviz.plot(dag_OSD366)

# print(arcs(dag_OSD366))
# print(nodes(dag_OSD366))

# Get the nodes that do not have incoming or outgoing arcs
nodes_with_arcs <- c(unique(arcs(dag_OSD366)[, "from"]), unique(arcs(dag_OSD366)[, "to"]))
nodes_to_delete <- setdiff(nodes(dag_OSD366), nodes_with_arcs)

# Create a copy of the original DAG to work with
dag_cleaned <- dag_OSD366

# Loop through each node to delete
for (node in nodes_to_delete) {
  dag_cleaned <- remove.node(dag_cleaned, node)
}

values_to_include <- c('1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
                       '11', '12', '13', '14', '15', '16', '17', '18', '19', 'M', 'X', 'Y')


filtered_nodes <- nodes(dag_cleaned)[nodes(dag_cleaned) %in% values_to_include]
filtered_nodes <- as.character(filtered_nodes)
print(filtered_nodes)

# Delete the nodes without incoming or outgoing arcs
# dev.new()
graphviz.plot(dag_cleaned, highlight = list(nodes =filtered_nodes), render = TRUE)

print(random_subset)
write.csv(random_subset, "C:/Users/max/Desktop/output.csv", row.names = FALSE)

?graphviz.plot()






# cols_to_remove <- grep("\\.1$", colnames(OSD366), value = TRUE)
# 
# # Remove the identified columns
# OSD366 <- OSD366[, !(colnames(OSD366) %in% cols_to_remove)]
# 
# # Calculate the number of NA values in each row
# num_na_per_row <- rowSums(is.na(OSD366))
# 
# # Create a subset of rows with less than 32 NA values
# OSD366 <- OSD366[num_na_per_row < 32, ]
# 
# print(colnames(OSD366))
# 
# # OSD366 <- OSD366[1: 53000, ]






# _____________________________________________________________________________________

#read in file
chromosome <- read.csv("C:/Users/max/Desktop/Home/DAG/publications/OSD-366/chromosomes/chromosome_1.csv")

# colnames(chromosome)

chromosome$chromosome <- NULL
chromosome$Bgd_Si.350.MeV.n_4 <- NULL
chromosome$FociPerGy_Si.350.MeV.n_4 <- NULL
chromosome$Bgd_Si.350.MeV.n_8 <- NULL
chromosome$FociPerGy_Si.350.MeV.n_8 <- NULL
chromosome$Bgd_Si.350.MeV.n_24  <- NULL      
chromosome$FociPerGy_Si.350.MeV.n_24 <- NULL
chromosome$Bgd_Si.350.MeV.n_48 <- NULL
chromosome$FociPerGy_Si.350.MeV.n_48 <- NULL
chromosome$Bgd_Ar.350.MeV.n_4 <- NULL
chromosome$FociPerGy_Ar.350.MeV.n_4 <- NULL
chromosome$Bgd_Ar.350.MeV.n_8 <- NULL
chromosome$FociPerGy_Ar.350.MeV.n_8 <- NULL
chromosome$Bgd_Ar.350.MeV.n_24 <- NULL
chromosome$FociPerGy_Ar.350.MeV.n_24 <- NULL
chromosome$Bgd_Ar.350.MeV.n_48 <- NULL
chromosome$FociPerGy_Ar.350.MeV.n_48 <- NULL


colnames(chromosome) <- sub("FociPerGy", "Fpg", colnames(chromosome))
colnames(chromosome) <- sub("\\.MeV", "", colnames(chromosome))

chromosome_numeric <- apply(chromosome, 2, as.numeric)
chromosome <- as.data.frame(chromosome_numeric)

chromosome <- chromosome[sample(nrow(chromosome), size = 300), ]

# Convert the "position.b38." column to a factor
chromosome$position.b38. <- as.factor(chromosome$position.b38.)

# One-hot encode the "position.b38." column
one_hot_encoded <- model.matrix(~position.b38. - 1, data = chromosome)

# Convert the result to a dataframe
one_hot_encoded_df <- as.data.frame(one_hot_encoded)

# Get the original column names for non-encoded columns
original_column_names <- colnames(chromosome)[-which(names(chromosome) == "position.b38.")]

# Extract the numeric part of the column names (remove "position.b38.")
numeric_column_names <- sub("position.b38.", "", levels(chromosome$position.b38.))

# Combine the original columns with the one-hot encoded columns and rename
combined_df <- cbind(chromosome[original_column_names], one_hot_encoded_df)
colnames(combined_df) <- c(original_column_names, numeric_column_names)


dim(combined_df)
# head(combined_df)
dag_chromosome <- pc.stable(combined_df)

nodes_with_arcs_chromosome <- c(unique(arcs(dag_chromosome)[, "from"]), unique(arcs(dag_chromosome)[, "to"]))
nodes_to_delete_chromosome <- setdiff(nodes(dag_chromosome), nodes_with_arcs_chromosome)

for (node in nodes_to_delete_chromosome) {
  dag_chromosome <- remove.node(dag_chromosome, node)
}

graphviz.plot(dag_chromosome)

print(arcs(dag_chromosome))
print(nodes(dag_chromosome))



# ===============================

# Function to extract chromosome numbers
extract_chromosome_numbers <- function(dag, variable_names) {
  # Initialize a list to store chromosome numbers
  chromosome_numbers <- list()
  
  # Loop through each variable name
  for (var_name in variable_names) {
    # Find parents of the variable in the DAG
    parents <- parents(dag, node = var_name)
    
    # Extract chromosome numbers from the parents
    chromosomes <- as.numeric(parents)
    
    # Remove NA values (e.g., for non-chromosome nodes)
    chromosomes <- chromosomes[!is.na(chromosomes)]
    
    # Store the chromosome numbers in the list
    chromosome_numbers[[var_name]] <- chromosomes
  }
  
  return(chromosome_numbers)
}

# Variables for which you want to extract chromosome numbers
variables_to_extract <- c(
  "Bgd_Fe.600.n_4", "Fpg_Fe.600.n_4",
  "Bgd_Fe.600.n_8", "Fpg_Fe.600.n_8",
  "Bgd_Fe.600.n_24", "Fpg_Fe.600.n_24",
  "Bgd_Fe.600.n_48", "Fpg_Fe.600.n_48",
  "Bgd_X.ray_4", "Fpg_X.ray_4",
  "Bgd_X.ray_24", "Fpg_X.ray_24",
  "Bgd_X.ray_48", "Fpg_X.ray_48"
)

# Call the function to extract chromosome numbers
chromosome_numbers <- extract_chromosome_numbers(dag_chromosome, variables_to_extract)

for (var_name in names(chromosome_numbers)) {
  cat("Variable:", var_name, "\n")
  cat("Chromosome Numbers:", chromosome_numbers[[var_name]], "\n\n")
}

