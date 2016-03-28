# Aim: allocate probabilities to flows
# source("R/dist-decay.R")
l = readRDS("Data/od-aepp.Rds")
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
