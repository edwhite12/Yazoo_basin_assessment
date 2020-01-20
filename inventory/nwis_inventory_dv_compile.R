setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory/turb')
outfile <- ('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory/turb_inventory_all.csv')
fs <- list.files()
minyear <- 2019
print(paste('checking for first year with data'))
for (f in fs)
{
  fd <-  read.csv(f)
  if (names(fd)[1] != 'x')
  {
    mny <- min(fd$WaterYear)
    minyear <- min(minyear,mny)
  }
}

years <- seq(minyear,2019)
dfout <- c('site',years)


for (f in fs)
{
  site <- strsplit(f,'_')[[1]][1] 
  siterow <- c(site)
  fd <-  read.csv(f)
  print(paste(site))
  if (names(fd)[1] != 'x')
  {
    for(yr in years)
    {
      if(yr %in% fd$WaterYear)
      {
        yr_ind <- match(yr,fd$WaterYear)
        yr_cnt <- fd$Count[yr_ind]
      }else
      {
        yr_cnt <- 0
      }
      siterow <- c(siterow,yr_cnt)
    }
  }else
  {
    for(yr in years)
    {
      siterow <- c(siterow,0)
    }
  }
  dfout <- rbind(dfout,siterow)  
}

write.table(dfout,outfile,row.names=FALSE,col.names=FALSE,sep=',')
