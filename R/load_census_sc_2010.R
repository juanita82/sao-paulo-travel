# Aim: Read 2010 Census data at the setor censitario level

library(raster)
library(foreign)
library(dplyr)

sc_zone <- shapefile("C:/Users/juanita82/Dropbox/Robin-SaoPaulo/SaoPaulo/Data/Shapefiles SPMR 2010/RM_Sao_Paulo_sc2010_CEM/SC2010_CEM_RMSAO.shp")

data<-read.dbf("C:/Users/juanita82/Dropbox/Robin-SaoPaulo/SaoPaulo/Data/Shapefiles SPMR 2010/RM_Sao_Paulo_sc2010_CEM/SC2010_CEM_RMSAO_p2.dbf")

keep<-c("CODSETTX", "P11_040" , "P11_041",  "P11_042", "P11_043", "P11_044", "P11_045", "P11_046", "P11_047", "P11_048", "P11_049", "P11_050", "P11_051", "P11_052", "P11_053", "P11_054", "P12_040" , "P12_041",  "P12_042", "P12_043", "P12_044", "P12_045", "P12_046", "P12_047", "P12_048", "P12_049", "P12_050", "P12_051", "P12_052", "P12_053", "P12_054")

data<-data[colnames(data) %in% keep]
colnames(data)[1]<-"CODSETOR"

sc_zone@data<-left_join(sc_zone@data, data, by = "CODSETOR")

sc_zone@data[is.na(sc_zone@data)]<-0

# Number of individuals aged 6-14 (fundamental school age range) in 2008 (equivalent to individuals 8-16 in 2010)
sc_zone@data$fund_2008 <-sc_zone@data$P11_040 + sc_zone@data$P11_041 + sc_zone@data$P11_042 + sc_zone@data$P11_043 + sc_zone@data$P11_044 + sc_zone@data$P11_045 + sc_zone@data$P11_046 + sc_zone@data$P11_047 + sc_zone@data$P11_048 + sc_zone@data$P12_040 + sc_zone@data$P12_041 + sc_zone@data$P12_042 + sc_zone@data$P12_043 + sc_zone@data$P12_044 + sc_zone@data$P12_045 + sc_zone@data$P12_046 + sc_zone@data$P12_047 + sc_zone@data$P12_048 

# Number of individuals aged 15-18 (fundamental school age range) in 2008 (equivalent to individuals 17-20 in 2010)
sc_zone@data$media_2008 <-sc_zone@data$P11_048 + sc_zone@data$P11_049 + sc_zone@data$P11_050 + sc_zone@data$P11_051 + sc_zone@data$P11_052 + sc_zone@data$P11_053 + sc_zone@data$P11_054 +   sc_zone@data$P12_048 + sc_zone@data$P12_049 + sc_zone@data$P12_050 + sc_zone@data$P12_051 + sc_zone@data$P12_052 + sc_zone@data$P12_053 + sc_zone@data$P12_054 
