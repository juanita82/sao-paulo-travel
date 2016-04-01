# Aim - load 'aep' data and find distances between them

library(raster)
library(rgeos)

spz = shapefile("Data/Shapefiles SPMR 2010/RM_Sao_Paulo_sc2010_CEM/SC2010_CEM_RMSAO.shp")
plot(spz[1:100,])
aep = shapefile("Data/Shapefiles SPMR 2010/aep10.shp")
plot(aep)

aepp = gCentroid(aep, byid = TRUE)
aepp = SpatialPointsDataFrame(aepp, aep@data)
points(aepp)
saveRDS(aepp, "Data/aepp.Rds")

# devtools::install_github("robinlovelace/stplanr")
library(stplanr)
l = points2flow(aepp) # large lines dataset - 400000!
geosphere::distHaversine(l[1,])

newcrs = stplanr::crs_select_aeq(l)
ltrans = spTransform(l, newcrs)

l$length = rgeos::gLength(l, byid = T)
summary(l$length)
proj4string(l)

l_all = l

l = l_all[l_all$length < 10000,]

plot(l)
head(l@data)
head(aepp@data)
saveRDS(l, "od-aepp.Rds")

l = readRDS("Data/od-aepp.Rds")


