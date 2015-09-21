# Aim: read in schools geo data

library(raster)

schools <- shapefile("../SaoPaulo/Data/escolas_SP_2008/Escolas_de_2008_georreferenciadas.shp")

plot(schools)
head