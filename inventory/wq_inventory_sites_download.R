library(dataRetrieval)
setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory')
#param <- 'Coliforms'
#param <- 'Coliform/Streptococcus ratio, fecal'
#param <- 'Total nonfecal coliform'
#param <- 'Total Coliform'
#param <- 'Fecal Streptococcus Group Bacteria'
param <- 'Fecal Coliform'


hucs <- c('08030203','08030201','08030204','08030202','08030205','08030206','08030207','08030209','08030208','08030100')

for (huc8 in hucs[1:10])
{
  print(huc8)
  outf <- paste('HUC',huc8,' ',param,'.csv',sep='')
  inv <- readWQPdata(huc=huc8,characteristicName=param)
  write.csv(inv,outf,row.names=FALSE)  
}

