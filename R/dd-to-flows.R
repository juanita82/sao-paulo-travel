# Aim: allocate probabilities to flows
source("R/dist-decay.R")
l = readRDS("Data/od-aepp.Rds")
# remove intra zonal flows
summary(l$O == l$D)
l = l[!l$O == l$D,]
summary(l$length)
l$length[l$length == 0] = 100
pdf = data.frame(x = l$length)
l$pcar = inv.logit(predict(object = mc, pdf))
plot(l$length / 1000, l$pcar, ylab = "Proportion who travel by mode", xlab = "Distance (km)",
     ylim = c(0, 0.8))
l$walk = inv.logit(predict(mw, pdf))
points(l$length / 1000, l$walk, col = "red")
l$cycle = inv.logit(predict(mcy, pdf))
points(l$length / 1000, 10 * l$cycle, col = "blue")
saveRDS(l, "Data/od-aepp.Rds")
l$time_car = (l$length / 1000) /
  11.757898 * # speed in km/hr
  60 # convert to minutes
summary(l$time_car)
l$time_bus = (l$length / 1000) / 8.113655 * 60
l$time_walk = (l$length / 1000) / 5.645529 * 60
l$time_cycle = (l$length / 1000) / 9.311568 * 60
saveRDS(l, "output-data/od-times.Rds")
odf = stplanr::points2odf(aep)
head(odf)
head(l)
odf = left_join(odf, l@data)
odf[is.na(odf)] = 0
write.csv(odf, "/tmp/odf.csv")
saveRDS(odf, "/tmp/odf.Rds")
