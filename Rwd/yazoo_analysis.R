plot_daily <- function(sn,pc,ct,st,end,plot=FALSE)  
{
  print(paste(' - downloading ',ct,' data'))
  
  # import daily 
  
  
  if(pc == '00600')
  {
    d <- readNWISqw(siteNumber=sn,parameterCd=pc,startDate=st,endDate=end)
    d <- renameNWISColumns(d)
    d <- cbind(d,as.numeric(format(as.Date(d$sample_dt,format="%Y-%dd-%mm"),"%Y")))
    d <- cbind(d,as.numeric(format(as.Date(d$sample_dt,format="%Y-%dd-%mm"),"%m")))
    d <- cbind(d,as.numeric(format(as.Date(d$sample_dt,format="%Y-%dd-%mm"),"%d")))
  }else if ( pc == '00060')
  {
    d <- readNWISdv(siteNumber=sn,parameterCd=pc,startDate=st,endDate=end)
    d <- renameNWISColumns(d)
    d <- cbind(d,as.numeric(format(as.Date(d$Date,format="%Y-%dd-%mm"),"%Y")))
    d <- cbind(d,as.numeric(format(as.Date(d$Date,format="%Y-%dd-%mm"),"%m")))
    d <- cbind(d,as.numeric(format(as.Date(d$Date,format="%Y-%dd-%mm"),"%d")))
  }
  
  names(d)[length(names(d))-2] <- 'Year'
  names(d)[length(names(d))-1] <- 'Month'
  names(d)[length(names(d))] <- 'Day'
  
  d <- cbind(d,d$Year)
  names(d)[length(names(d))] <- 'WaterYear'
  
  for (dn in seq(1,length(d$WaterYear)))
  {
    if(d$Month[dn] >= 10)
    {
      wy_offset <- 1
    }else
    {
      wy_offset <- 0
    }
    d$WaterYear[dn] <- paste(d$Year[dn]+wy_offset)
  }

  sty <- head(d$WaterYear,n=1)
  eny <- tail(d$WaterYear,n=1)
  csvn <- paste('USGS',sn,pc,sty,eny,'csv',sep='.')
  write.csv(d,csvn,row.names=FALSE)
  
  if(pc == '00600')
  {
    print(paste('mean =',mean(d$result_va),'mg/L'))
    print(paste('median =',median(d$result_va),'mg/L'))
    print(paste('stdev =',sd(d$result_va),'mg/L'))
    print(paste('min =',min(d$result_va),'mg/L'))
    print(paste('max =',max(d$result_va),'mg/L'))
    
    
  }else if (pc == '00060')
  {
    print(paste('mean =',mean(d$Flow),'cfs'))
    print(paste('median =',median(d$Flow),'cfs'))
    print(paste('stdev =',sd(d$Flow),'cfs'))
    print(paste('min =',min(d$Flow),'cfs'))
    print(paste('max =',max(d$Flow),'cfs'))
  }

  
  if (plot == TRUE)
  {
    print(paste(' - making plots'))
    
    bpn <- paste('USGS',sn,pc,sty,eny,'bx','png',sep='.')
    
    if (pc == '00600')
    {
      bptitle <- paste('Total N Statistics, ',sty,'-',eny,', USGS ',sn,sep='')
      bp <- ggplot(d,aes(x=d$WaterYear,y=d$result_va)) + geom_boxplot() + xlab('WaterYear') + ylab(ct)+ labs(title=bptitle)
    }else if(pc == '00060')
    {
      bptitle <- paste('Flow Statistics, ',sty,'-',eny,', USGS ',sn,sep='')
      bp <- ggplot(d,aes(x=d$WaterYear,y=d$Flow)) + geom_boxplot() + xlab('WaterYear') + ylab(ct)+ labs(title=bptitle)
    }
    
    ggsave(bpn)
    
    tsn <- paste('USGS',sn,pc,sty,eny,'ts','png',sep='.')
    
    if (pc == '00600')
    {
      tstitle <- paste('Total N, mg/L, ',sty,'-',eny,', USGS ',sn,sep='')
      ts <- ggplot(d,aes(x=d$sample_dt,y=d$result_va)) + geom_point(size=1,color='black') + xlab('Date') + ylab(ct)+ labs(title=tstitle)
    }else if (pc == '00060')
    {
      tstitle <- paste('Flowrate, cfs ',sty,'-',eny,', USGS ',sn,sep='')
      ts <- ggplot(d,aes(x=d$Date,y=d$Flow)) + geom_point(size=1,color='black') + xlab('Date') + ylab(ct)+ labs(title=tstitle)
    }
    
    ggsave(tsn)
    
    hsn <- paste('USGS',sn,pc,sty,eny,'hg','png',sep='.')
    
    if (pc == '00600')
    {
      hstitle <- paste('Total N Histogram, ',sty,'-',eny,', USGS ',sn,sep='')
      hs <- ggplot(d,aes(d$result_va)) 
    }else if ( pc == '00060')
    {
      hstitle <- paste('Flowrate Histogram, ',sty,'-',eny,', USGS ',sn,sep='')
      hs <- ggplot(d,aes(d$Flow)) 
    }
    
    hs + geom_histogram()
    hs + stat_bin(bins=100,boundary=0,color='black',fill='gray') + xlab(ct) + labs(title=hstitle)
    ggsave(hsn)
  
  }
  return 
}





library(dataRetrieval)
library(ggplot2)

setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/Rwd')
sites <-  read.csv('yazoo_sites.txt',colClasses=c('character','character'))

codes <- c('00060', '00600')
codes_text <- c('Flowrate, cfs','Total N, mg/L')

start.date <- '2009-10-01'
end.date <- '2018-09-30'

for (n in seq(1,nrow(sites)))
{
  site <- sites[n,1]
  desc <-  sites[n,2]
  
  print(paste('processing site',site,'|',desc))
  
  for (ci in seq(1,length(codes)))
  {
    c <- codes[ci]
    ctx <- codes_text[ci]
    print(paste('parameter code = ',c,sep=''))
    plot_daily(sn=site,pc=c,ct=ctx,st=start.date,end=end.date,plot=TRUE)
    
  }
}



