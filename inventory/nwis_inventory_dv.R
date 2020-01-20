library(dataRetrieval)
setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/Rwd')
sites <-  read.csv('yazoo_sites_all.txt',colClasses=c('character','character'))
dv_pcs_all <- c()

for (n in seq(1,nrow(sites)))
{
  sn <- sites[n,1]
  desc <- sites[n,2]
  print(paste('processing site',sn,'|',desc))

  dv_inv <- whatNWISdata(siteNumber=sn,service='dv')
  dv_pgs <- unique(dv_inv$parm_grp_cd)
  dv_pcs <- unique(dv_inv$parm_cd)
  dv_pcs_all <- c(dv_pcs_all,dv_pcs)
  
  if(nrow(dv_inv)>0)
  {
     for(pc in c('80155'))#dv_pcs)
    {
      if(pc %in% dv_pcs)
      {
        dv <- readNWISdv(siteNumber=sn,parameterCd=pc)#,startDate=st,endDate=end)
        if(length(dv)>0)
        {
          dv <- renameNWISColumns(dv)
          dv <- cbind(dv,as.numeric(format(as.Date(dv$Date,format="%Y-%dd-%mm"),"%Y")))
          dv <- cbind(dv,as.numeric(format(as.Date(dv$Date,format="%Y-%dd-%mm"),"%m")))
          dv <- cbind(dv,as.numeric(format(as.Date(dv$Date,format="%Y-%dd-%mm"),"%d")))
          names(dv)[length(names(dv))-2] <- 'Year'
          names(dv)[length(names(dv))-1] <- 'Month'
          names(dv)[length(names(dv))] <- 'Day'
          dv <- cbind(dv,dv$Year)
          names(dv)[length(names(dv))] <- 'WaterYear'
          for (dn in seq(1,length(dv$WaterYear)))
          {
            if(dv$Month[dn] >= 10)
            {
              wy_offset <- 1
            }else
            {
              wy_offset <- 0
            }
            dv$WaterYear[dn] <- paste(dv$Year[dn]+wy_offset)
          } # end of calculate WaterYear for loop
          dv_smry <- aggregate(dv[,4]~WaterYear,dv,length)
          dv_smry <- cbind(dv_smry,aggregate(dv[,4]~WaterYear,dv,mean)[,2])
          dv_smry <- cbind(dv_smry,aggregate(dv[,4]~WaterYear,dv,median)[,2])
          dv_smry <- cbind(dv_smry,aggregate(dv[,4]~WaterYear,dv,sd)[,2])
          dv_smry <- cbind(dv_smry,aggregate(dv[,4]~WaterYear,dv,min)[,2])
          dv_smry <- cbind(dv_smry,aggregate(dv[,4]~WaterYear,dv,max)[,2])
          names(dv_smry) <- c('WaterYear','Count','Mean','Median','StDev','Min','Max')
        }else
        {
          dv_smry <- paste('No daily suspended sediment load data for site.')
        }# end of ifelse if no data was downloaded and length(dv)
        
      }else
      {
        dv_smry <- paste('No daily suspended sediment load data for site.')
      }# end of ifelse pc in dv_pcs loop
    } # end of for pc loop
  }else
  {
    dv_smry <- paste('No daily data of any type for site.')
  }# end of if dv_inv > 0 loop
  
  outdir <- 'D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory/sed_tpd/'
  csvfn <- paste(outdir,sn,"_",pc,".csv",sep='')
  write.csv(dv_smry,csvfn,row.names=FALSE)

} # end of for sn loop

dv_pcs_all <- unique(dv_pcs_all)
sumdir <- 'D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory/'
pcfn <- paste(sumdir,'daily_codes_found.csv',sep='')
write.csv(dv_pcs_all,pcfn,row.names=FALSE)

#qw_inv <- whatNWISdata(siteNumber=sn,service='qw')
#qw_pgs <- unique(qw_inv$parm_grp_cd)
#qw_pcs <- unique(qw_inv$parm_cd)
#qw <- readNWISqw(siteNumber=sn,parameterCd=pc,startDate=st,endDate=end)
