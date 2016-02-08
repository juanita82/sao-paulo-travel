# Aim: read in schools geo data

library(raster)

file.rename("/tmp/data/escolas_SP_2008/ESCOLAS_DE_2008_GEORREFERENCIADAS.dbf", "/tmp/data/escolas_SP_2008/Escolas_de_2008_georreferenciadas.dbf")
schools <- shapefile("/tmp/data/escolas_SP_2008/Escolas_de_2008_georreferenciadas.shp")

proj4string(schools) <- CRS("+init=epsg:4326")

library(tmap)
library(leaflet)
leaflet() %>% addTiles() %>% addCircles(data = schools)
plot(schools)
head