# Aim: find average speeds by mode (and distance?) from the OD survey
library(dplyr)
source("R/load_OD_2007.R")

summary(od_flow$DURACAO)
summary(od_flow$Distance)

od_flow$Speed = (od_flow$Distance / 1000) / (od_flow$DURACAO / 60)  

speedtable = group_by(od_flow, mode) %>%
  summarise(Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))

speedtable2 = filter(od_flow, student == "Medio") %>% 
  group_by(mode) %>%
  summarise(Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))

st = cbind(speedtable, speedtable2[2:4])[-9,]
st[9,2:7] = colMeans(st[2:7])
st$mode = as.character(st$mode)
st[9,1] = "Average"
write.csv(st, "output-data/speed-table.csv")

source("R/student-flows.R")
od_flows = filter(od_flows, student == "Medio")

# Summarise speed, %, distance, time by public/private
od_flows = filter(od_flows, !is.na(TIPO_ESC))
st_tipo_esc = group_by(od_flows, TIPO_ESC) %>%
  summarise(Percent = n() / nrow(od_flows) * 100,
            Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))
  
write.csv(st_tipo_esc, "output-data/st-tipo-esc.csv")

# Summarise speed, %, distance, time by public/private
st_tipo_esc_mode = group_by(filter(od_flows, Mode_type != "Other"), TIPO_ESC, Mode_type) %>%
  summarise(Percent = n() / nrow(od_flows) * 100,
            Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))
write.csv(st_tipo_esc, "output-data/st-tipo-esc-.csv")

group_by(filter(od_flows, Mode_type != "Other" & TIPO_ESC == 1), TIPO_ESC, Mode_type) %>%
  summarise(Percent = n() / 2468 * 100,
            Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))

type_mode_table = group_by(filter(od_flows, Mode_type != "Other"), School_type, Mode_type) %>%
  summarise(Percent = n() / nrow(od_flows) * 100,
            Distance = mean(Distance/ 1000, na.rm = T),
            Time = mean(DURACAO),
            Speed = mean(Speed, na.rm = T))

write.csv(type_mode_table, "output-data/type_mode_table.csv")
