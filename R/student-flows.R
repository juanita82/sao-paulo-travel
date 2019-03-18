# subset young people that study by their age range

# Explore flow data
summary(factor(od_flow$MOTIVO_D)) / nrow(od_flow)

# Number of potential students of ensino basico y medio (below 15 years old)
table(od_flow$IDADE <= 15 & od_flow$IDADE >= 6)
table(od_flow$IDADE > 15 & od_flow$IDADE <= 18)
# subset young people that study by their age range
#sel_age <- od_flow$IDADE <= 18 & od_flow$IDADE >= 6
#od_flow <- od_flow[sel_age,]
#summary(factor(od_flow1$MOTIVO_D)) / nrow(od_flow1) # % education -> 40%

sel_level <- od_flow$student == "Fundam" | od_flow$student== "Medio"
od_flows <- od_flow[sel_level,]

# subsetting by motive to destination (school)
sel_why <- od_flows$MOTIVO_D == 4 & !is.na(od_flows$MOTIVO_D)
od_flows <- od_flows[sel_why,] # now 15,000 trips
length(unique(od_flows$ID_PESS))
dup_od <- duplicated(od_flows$ID_PESS)
od_dup <- od_flows[od_flows$ID_PESS %in% od_flows$ID_PESS[dup_od], ]
od_flows <- od_flows[!dup_od,]
od_flows$mode2 <- NA
for(i in 2 * (1:(nrow(od_dup)/2))){
  df_tmp <- od_dup[(i-1):i, c("mode", "DURACAO")]
  sel <- od_flows$ID_PESS == od_dup$ID_PESS[i]
  od_flows$mode[sel] <- df_tmp$mode[which.max(df_tmp$DURACAO)]
  od_flows$mode2[sel] <- "other"
  od_flows$mode2[sel] <- df_tmp$mode[which.min(df_tmp$DURACAO)]
}
sum(!is.na(od_flows$mode2)) / nrow(od_flows)
# alternative way with aggregate...
# dup_time <- aggregate(DURACAO ~ ID_PESS, FUN = "sum", data = od_flows[c("ID_PESS", "DURACAO")])

summary(factor(od_flows$MOTIVO_D)) / nrow(od_flows) # % education -> 41%
summary(od_flows$student)
summary(factor(od_flows$MOTIVO_D))
# summary(od_flows$MOTIVO_O)
#
# length(unique(od_flows$CO_ESC_X))
# sel_esc = !duplicated(od_flows$CO_ESC_X)
# sum(sel_esc)
# od_flowu = od_flows[sel_esc,]
#
# # How many of each kind?
# table(od_flowu$type)
# sel_pub = od_flowu$type=="Public"
# od_flowup = od_flowu[sel_pub,]
# od_flowupr = od_flowu[!sel_pub,]
#
# # Compare mode selection by type of school
# summary(factor(od_flowup$mode)) / nrow(od_flowup)
# summary(factor(od_flowupr$mode)) / nrow(od_flowupr)
#
#
# # Plotting schools by their XY coordinates (56,497 schools)
# # School trips data
# cord_esc_X<-od_flowup$CO_ESC_X[!is.na(od_flowup$CO_ESC_X)]
# cord_esc_Y<-od_flowup$CO_ESC_Y[!is.na(od_flowup$CO_ESC_Y)]
# coord_esc<-as.data.frame(cbind(cord_esc_X, cord_esc_Y))
# plot(coord_esc)
