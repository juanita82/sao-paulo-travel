# Load micro-data Censos Escolar 2000

library(SAScii)

escolas2000<-read.SAScii( "C:/Users/juanita82/Dropbox/Escolas/micro_censo_escolar2000/DADOS_CENSOESC/DADOS_CENSOESC.txt", "C:/Users/juanita82/Dropbox/Escolas/micro_censo_escolar2000/Import/INPUT_SAS_CENSOESC.sas", beginline = 6, buffersize = 50, zipped = F , n = -1 , intervals.to.print = 10 , lrecl = NULL , skip.decimal.division = NULL )
