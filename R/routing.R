# Aim: generate routes between ODs
pkgs = c("tmap", "rgdal", "rgeos", "mapview", "stplanr", "geosphere", "dplyr")
lapply(pkgs, library, character.only = T)
cents = read_shape("Data/AEP_2010_codes/aep10.shp")
cents = spTransform(x = cents, CRSobj = CRS("+init=epsg:4326"))
qtm(cents)
mapview(cents)

f = read.csv("Data/centroids_60min.csv")

l = od2line(flow = f, zones = cents)
mapview(l)
ldf = line2df(l)
# l$dist = gLength(l, byid = T)
l$dist_hav = distHaversine(ldf[1:2], ldf[3:4])
summary(l$dist)
summary(l$dist_hav)
# subset early
l_all = l
l = l[l$dist_hav < 1000,]
mapview(l)
nrow(l)

# route_graphhopper(from = ldf[2,1:2], to = ldf[2, 3:4])
rc = line2route(l = l[1:20,], route_fun = "route_graphhopper", vehicle = "car")
rf = line2route(l = l[1:20,], route_fun = "route_graphhopper", vehicle = "foot")
summary(rf)
nrow(rf)

r_out = cbind(l@data[1:20,], ldf[1:20,], rc@data[1:20,], rf@data)
names(r_out)[c(9:10, 12:13)] = c("time_car", "dist_car", "time_foot", "dist_foot")
summary(r_out)
write.csv(r_out, "output-data/sample-time-od-out.csv")
