# Aim: Read (.mdb) OD 2007 data

setwd("C:/Users/juanita82/Dropbox/Robin-SaoPaulo/SaoPaulo/Data/OD-2007/")

data<-read.table("OD_2007.txt", sep=",")

colnames(data)<-c("ZONA",  "MUNI_DOM",	"CO_DOM_X",	"CO_DOM_Y",	"ID_DOM",	"F_DOM",	"FE_DOM",	"DOM",	"CD_ENTRE",	"DATA",	"TIPO_DOM",	"NO_MORAD",	"TOT_FAM",	"ID_FAM",	"F_FAM",	"FE_FAM",	"FAMILIA",	"NO_MORAF",	"CONDMORA",	"QT_RADIO",	"QT_GEL1",	"QT_GEL2",	"QT_TVCOR",	"QT_FREEZ",	"QT_VIDEO",	"QT_BANHO",	"QT_MOTO",	"QT_AUTO",	"QT_ASPIR",	"QT_MLAVA",	"QT_EMPRE",	"QT_MICRO",	"QT_BICICLE",	"NAO_DCL_IT",	"CRITERIO_B",	"ANO_AUTO1",	"ANO_AUTO2",	"ANO_AUTO3",	"RENDA_FA",	"CD_RENFA",	"ID_PESS",	"F_PESS",	"FE_PESS",	"PESSOA",	"SIT_FAM",	"IDADE",	"SEXO",	"ESTUDA",	"GRAU_INS",	"CD_ATIVI",	"CO_REN_I",	"VL_REN_I",	"ZONA_ESC",	"MUNIESC",	"CO_ESC_X",	"CO_ESC_Y",	"TIPO_ESC",	"ZONATRA1",	"MUNITRA1",	"CO_TR1_X",	"CO_TR1_Y",	"TRAB1_RE",	"TRABEXT1",	"OCUP1",	"SETOR1",	"VINC1",	"ZONATRA2",	"MUNITRA2",	"CO_TR2_X",	"CO_TR2_Y",	"TRAB2_RE",	"TRABEXT2",	"OCUP2",	"SETOR2",	"VINC2",	"N_VIAG",	"FE_VIA",	"DIA_SEM",	"TOT_VIAG",	"ZONA_O",	"MUNI_O",	"CO_O_X",	"CO_O_Y",	"ZONA_D",	"MUNI_D",	"CO_D_X",	"CO_D_Y",	"ZONA_T1",	"MUNI_T1",	"CO_T1_X",	"CO_T1_Y",	"ZONA_T2",	"MUNI_T2",	"CO_T2_X",	"CO_T2_Y",	"ZONA_T3",	"MUNI_T3",	"CO_T3_X",	"CO_T3_Y",	"MOTIVO_O",	"MOTIVO_D",	"SERVIR_O",	"SERVIR_D",	"MODO1",	"MODO2",	"MODO3",	"MODO4",	"H_SAIDA",	"MIN_SAIDA",	"ANDA_O",	"H_CHEG",	"MIN_CHEG",	"ANDA_D",	"DURACAO",	"MODOPRIN",	"TIPOVG",	"PAG_VIAG",	"TP_ESAUTO",	"VL_EST",	"PE_BICI",	"TP_ESBICI",	"ID_ORDEM")

# School trips data
table(is.na(data$CO_ESC_X))
# Number of potential students of ensino basico y medio (below 15 years old)
table(data$IDADE<15)
