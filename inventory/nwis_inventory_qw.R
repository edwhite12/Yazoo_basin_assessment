library(dataRetrieval)
setwd('D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory')
sites <-  read.csv('yazoo_sites_all.txt',colClasses=c('character','character'))
dv_pcs_all <- c()

for(pg in c('BIO','INF','INM','INN','IMM','IMN','MBI','NUT','OOT','OPC','OPE','PHY','POP','RAD','SED','ISO','TOX'))
{
  dfout <- c('site','parm_group_code','obs_count','start_date','end_date','parm_codes')
  
  for (n in seq(1,nrow(sites)))
  {
    sn <- sites[n,1]
    desc <- sites[n,2]
    print(paste('processing ',pg,' data for site',sn,'|',desc))
    
    qw_inv <- whatNWISdata(siteNumber=sn,service='qw')
    Viewqw_pgs <- unique(qw_inv$parm_grp_cd)
    qw_pcs <- unique(qw_inv$parm_cd)
    
    count <- 0
    earliest <- '2020'
    latest <-  '1776'
    prms <- c()
    
    if(length(qw_pgs)==0)
    {
      earliest <- '-'
      latest <-  '-'
    }else
    {
      for (r in seq(1,length(qw_inv$parm_grp_cd)))
      {
        if(is.na(qw_inv$parm_grp_cd[r]) == FALSE)
        {
          if(qw_inv$parm_grp_cd[r] == pg)
          {
            count <- count + qw_inv$count_nu[r]
            earliest <- min(earliest,substring(qw_inv$begin_date[r],1,4))
            latest <- max(latest,substring(qw_inv$end_date[r],1,4))
            if(qw_inv$parm_cd[r] %in% prms == FALSE)
            {
              prms <- c(prms,qw_inv$parm_cd[r])
            } # end of loop that examines for unique parm_cd for parm_grp_cd of interest        
          }
          
        } # end if parm_grp_cd is equal to pg of interest
      } # end r for loop
    }
    
    parm_cd_block <- '-'
    for(pcd in prms)
    {
      if(parm_cd_block=='-')
      {
        parm_cd_block <- pcd
      }else
      {
        parm_cd_block <- paste(parm_cd_block,pcd,sep='-')
      }
    }
    if(earliest == 2020)
    {
      earliest <- '-'
    }
    if(latest == 1776)
    {
      latest <- '-'
    }
    siterow <- c(sn,pg,count,earliest,latest,parm_cd_block)
    dfout <- rbind(dfout,siterow)
  } # end of for sn loop
  
  
  # qw <- readNWISqw(siteNumber=sn,parameterCd=pc,startDate=st,endDate=end)
  
  
  outdir <- 'D:/OneDrive - Tulane University/RCSE-6840 files/Yazoo/inventory/water_quality_data/'
  csvfn <- paste(outdir,pg,"_inventory_all.csv",sep='')
  write.table(dfout,csvfn,row.names=FALSE,col.names=FALSE,sep=',')
}
