# Aim: get distance decay curves from individual-level (to generalise)
library(dplyr)
library(boot)

source("R/load_OD_2007.R")

# # what's the distribution?
# hist(od_flow$)
dist_breaks = seq(from = 0, to = 30, by = 0.2) * 1000
od_flow$dband = cut(od_flow$Distance, dist_breaks)


od_flow = od_flow[!is.na(names(od_flow))]

summary(od_flow$mode)

agflow =
  group_by(od_flow, dband) %>% summarise(
  n = n(),
  x = mean(Distance, na.rm = T),
  pwalk = sum(mode == "Walk") / length(mode),
  pcycle = sum(mode == "Bicycle") / length(mode),
  pcar = sum(mode == "Car") / length(mode)
  )
agflow$p = agflow$pwalk
plot(agflow$x / 1000, agflow$p, ylab = "Proportion who walk", xlab = "Distance (km)")
# plot(agflow$x, logit(agflow$p))
# plot(agflow$x, inv.logit(logit(agflow$p)))
# Aim: convert distances to probability of walking/cycling
ddform = formula(logit(p) ~ x + I(x^2) + I(x^3))
# agflow = filter(agflow, !is.na(p))
agflow$p[agflow$p == 0] = 0.001
summary(agflow$p)
m = lm(formula = ddform, data = agflow)
mw = lm(formula = ddform, data = agflow, na.action = "na.exclude", weights = n)
lines(m$model$x / 1000, inv.logit(m$fitted.values))
lines(m$model$x / 1000, inv.logit(mw$fitted.values), col = "blue")
points(agflow$x / 1000, agflow$p, ylab = "Proportion who walk", xlab = "Distance (km)",
     cex = agflow$n / mean(agflow$n))
# job done, for walking at least - now other modes
agflow$p = agflow$pcar
plot(agflow$x / 1000, agflow$p, ylab = "Proportion by car", xlab = "Distance (km)")
ddform = formula(logit(p) ~ log(x) + I(log(x)^2) + I(log(x)^3))
agflow = filter(agflow, !is.na(p))
agflow$p[agflow$p == 0] = 0.001
m = lm(formula = ddform, data = agflow)
mc = glm(formula = ddform, data = agflow, na.action = "na.exclude", weights = n)
lines(agflow$x / 1000, inv.logit(m$fitted.values))
lines(agflow$x / 1000, inv.logit(mc$fitted.values))
saveRDS(mc, "output-data/mc.Rds")
# cycling
agflow$p = agflow$pcycle
plot(agflow$x / 1000, agflow$p, ylab = "Proportion who cycle", xlab = "Distance (km)")
ddform = formula(logit(p) ~ log(x) + I(log(x)^2) + I(x^3))
# agflow = filter(agflow, !is.na(p))
agflow$p[agflow$p == 0] = 0.001
m = lm(formula = ddform, data = agflow)
mcy = lm(formula = ddform, data = agflow, weights = agflow$n)
lines(agflow$x / 1000, inv.logit(m$fitted.values))
lines(agflow$x / 1000, 2 * inv.logit(mcy$fitted.values), col = "blue")
points(agflow$x / 1000, agflow$p, ylab = "Proportion who walk", xlab = "Distance (km)",
       cex = agflow$n / mean(agflow$n))
saveRDS(mcy, "output-data/mcy.Rds")
# plot(agflow$x, logit(agflow$p))
# plot(agflow$x, inv.logit(logit(agflow$p)))
# # experimental curves:
# plot(agflow$x / 1000, agflow$p, ylab = "Proportion who walk", xlab = "Distance (km)")
# # plot(agflow$x, logit(agflow$p))
# # plot(agflow$x, inv.logit(logit(agflow$p)))
# 
# # explore the logit function
# logit(agflow$p)
# logit(100)
# inv.logit(100)
# inv.logit(-100)
# 
# # Aim: convert distances to probability of walking/cycling
# ddform = formula(p ~ log(x) + I(x^2) + I(x^3))
# agflow = filter(agflow, !is.na(p))
# agflow$p[agflow$p == 0] = 0.001
# summary(agflow$p)
# m = lm(formula = ddform, data = agflow)
# mw = lm(formula = ddform, data = agflow, na.action = "na.exclude", weights = n)
# lines(agflow$x / 1000, m$fitted.values)
# lines(agflow$x / 1000, mw$fitted.values, col = "blue")
# lines(agflow$x / 1000, inv.logit(m$fitted.values))
# lines(agflow$x / 1000, inv.logit(mw$fitted.values), col = "blue")