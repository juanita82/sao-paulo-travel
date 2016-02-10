# Aggregate trips
# Aim: find the number of students by mode travelling on each home:school route in the data

# od_flows with source("load_OD_2007")

# stage 1: identify unique lines
nrow(od_flow)
sel_u <- !duplicated(od_flow[c("CO_O_X", "CO_O_Y")])
od_flowu <- od_flow[sel_u,]
cents_o <- zones
cents_d <- schools
head(zones)


library(stplanr)
od2line()

# stage 2: snap lines to school/residential areas

# stage 3: aggregate flows

# stage 4 convert into lines
