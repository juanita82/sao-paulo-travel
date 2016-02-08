# Aim: read in schools geo data

library(raster)

# 1 loading data
file.rename("/tmp/data/escolas_SP_2008/ESCOLAS_DE_2008_GEORREFERENCIADAS.dbf", "/tmp/data/escolas_SP_2008/Escolas_de_2008_georreferenciadas.dbf")
schools <- shapefile("/tmp/data/escolas_SP_2008/Escolas_de_2008_georreferenciadas.shp")
proj4string(schools) <- CRS("+init=epsg:4326")

zones <- shapefile("/tmp/data/Shapefiles SPMR 2010/aep10.shp")
zones <- spTransform(zones, proj4string(schools))

od <- 

plot(zones)
points(schools, col = "red")
schools <- schools[zones,] # select only those in zones
points(schools, col = "green")
nrow(schools)
df <- schools@data
View(df)
plot(df$ALE_1_4 + df$ALE_5_8, df$TOT_MATR)
cor(df$ALE_1_4 + df$ALE_5_8, df$TOT_MATR, use = "complete.obs")

# which schools to use

# Visualising data
library(tmap)
library(leaflet)
leaflet() %>% addTiles() %>% addCircles(data = schools)
plot(schools)
head