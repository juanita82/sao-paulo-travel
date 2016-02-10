# Aggregate trips
# Aim: find the number of students by mode travelling on each home:school route in the data
library(sp)
library(rgeos)

# od_flows with source("load_OD_2007")

# stage 1: identify unique lines
nrow(od_flow)
sel_u <- !duplicated(od_flow[c("CO_O_X", "CO_O_Y")])
od_flowu <- od_flow[sel_u,]
# remove ones with na coords
sel_nacoords <- is.na(od_flowu$CO_O_X) | is.na(od_flowu$CO_O_Y)
sum(sel_nacoords)
od_flowu <- od_flowu[!sel_nacoords,]

cents_o <- gCentroid(zones, byid = T)
cents_d <- schools

flow_o <- SpatialPoints(cbind(od_flowu$CO_O_X, od_flowu$CO_O_Y))
flow_d <- SpatialPoints(cbind(od_flowu$CO_D_X, od_flowu$CO_D_Y))
proj4string(flow_o) <- proj4string(flow_d) <- CRS("+init=epsg:29183")
flow_o <- spTransform(flow_o, proj4string(schools))
flow_d <- spTransform(flow_d, proj4string(schools))

# distance to schools
# sdists <- spDists(flow_o, schools, longlat = T)
# mindists_o <- apply(sdists, 1, which.min)
# sdists <- spDists(flow_d, schools, longlat = T)
# mindists_d <- apply(sdists, 1, which.min)
# summary(mindists_o) 
# summary(mindists_d) # no discernable difference - select only destinations near schools

# subset flows that go to the 2201 schools - 4 for edu. performance
# for route analysis (stats on od_flowu)
# for analysis of mode choice etc use od_flows
library(stplanr)
buff_school <- buff_geo(schools, width = 500)
plot(buff_school)
flow_d <- SpatialPointsDataFrame(flow_d, od_flowu)
flow_s <- flow_d[buff_school,]
summary(row.names(flow_s))
od_school <- 

# check the flows overlap
plot(schools)
points(flow_o)
bbox(flow_dest)
bbox(zones)


library(stplanr)
od2line()

# stage 2: snap lines to school/residential areas

# stage 3: aggregate flows

# stage 4 convert into lines
