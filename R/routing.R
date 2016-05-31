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
l$fare = NA

# for(i in 1:nrow(l)){
for(i in 12001:nrow(l)){
  flag <- TRUE
  tryCatch({
    dists = dist_google(line2points(l[i,])[1,], line2points(l[i,])[2,],
                        mode = "transit", arrival_time = brtime,
                        google_api = Sys.getenv("GOOGLEDIST"))
    l$from_addresses[i] = as.character(dists$from_addresses)
    l$to_addresses[i] = as.character(dists$to_addresses)
    l$distances[i] = dists$distances
    l$duration[i] = dists$duration
    l$fare[i] = dists$fare
  },
    error=function(e) flag<<-FALSE
  )
  if (!flag) next
}

ldff = l@data
l$dist_hav_km = l$dist_hav / 1000

# plotting
l$dist_band = cut(l$dist_hav_km, breaks = quantile(l$dist_hav_km))
l$color = cut(l$dist_hav_km, breaks = quantile(l$dist_hav_km),
              labels = c("green", "blue", "yellow", "red"))
l$color = as.character(l$color)
plot(ldff$dist_hav / 1000, ldff$distances / 1000,
    ylab = "Public transport distance (km)",
    xlab = "Euclidean distance (km)", col = l$color)



library(tmap)
tmap_mode("view")
osm_tiles = tmap::read_osm(l)
tm_shape(osm_tiles) +
  tm_raster() +
  tm_shape(l) +
  tm_lines(col = "dist_band")






qtm(l, line.col = "dist_hav_km")

write.csv(ldff, "output-data/sample-time-od-out.csv")
