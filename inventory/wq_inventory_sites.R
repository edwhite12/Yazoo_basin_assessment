library(dataRetrieval)
setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/assessment')
param <- 'Turbidity'#'Total suspended solids'#'Temperature, water'#"Kjeldahl nitrogen"#'Nitrogen'#Coliform/Streptococcus ratio, fecal'#'Total nonfecal coliform'#'Total Coliform'#'Fecal Streptococcus Group Bacteria'#'Fecal Coliform'

outf <- paste(param,' data.csv',sep='')

hucs <- c('08030201','08030203','08030204','08030202','08030205','08030206','08030207','08030209','08030208','08030100')

huc8 = hucs[1]
print(huc8)
outinv <- readWQPdata(huc=huc8,characteristicName=param)
#whatWQPsites
#r
for (huc8 in hucs[2:10])
{
  print(huc8)
  inv <- readWQPdata(huc=huc8,characteristicName=param)#readWQPdata
  if (ncol(inv)==ncol(outinv))
  {
    outinv <- rbind(outinv,inv)
  }else
  {
    print(paste(huc8,' has only ',ncol(inv),' columns - not appending to table'))
  }
    
}

write.csv(outinv,outf,row.names=FALSE)