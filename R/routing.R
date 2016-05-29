# Aim: generate routes between ODs
pkgs = c("sp", "tmap", "rgdal", "rgeos", "stplanr", "geosphere", "dplyr")
lapply(pkgs, library, character.only = T)
cents = read_shape("Data/aep10.shp")
# cents = gCentroid(cents, byid = T)
cents = spTransform(x = cents, CRSobj = CRS("+init=epsg:4326"))
qtm(cents)
mapview(cents)

f = read.csv("Data/centroids_60min.csv")

odf = points2odf(cents)
brtime = strptime("2016-05-26 09:00:00", format = "%Y-%m-%d %H:%M:%S", tz = "BRT")


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

# The google dist matrix api way

l@data = cbind(l@data, dists)
class(l$from_addresses) 
l@data[4:7] = NA
lapply(l@data, class)
class(l$from_addresses) = "character"
class(l$to_addresses) = "character"
class(l$distances) = "numeric"
class(l$duration) = "numeric"

# for(i in 1:nrow(l)){
for(i in 1:100){
  flag <- TRUE
  tryCatch({
    dists = dist_google(line2points(l[i,])[1,], line2points(l[i,])[2,],
                        mode = "transit", arrival_time = brtime)
    l$from_addresses[i] = as.character(dists$from_addresses)
    l$to_addresses[i] = as.character(dists$to_addresses)
    l$distances[i] = dists$distances
    l$duration[i] = dists$duration
  },
    error=function(e) flag<<-FALSE
  )
  if (!flag) next

}
ldff = l@data
write.csv(ldff, "output-data/sample-time-od-out.csv")
