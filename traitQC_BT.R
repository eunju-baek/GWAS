#!/usr/bin/env Rscript

argv = commandArgs(trailingOnly=TRUE)

action = argv[1]
env = argv[2]
traitID = argv[3]
case_code = argv[4]
name = argv[5]

library(data.table)
library(dplyr)

a <- fread("root_discovery.txt")
a <- data.frame(a)

b <- fread(env)
b <- data.frame(b)


c <- select(b,c('eid',traitID))

if(action == "--asthma"){
        names(c)[1] <- "asthma_eid"
        d <- left_join(a,c,by="asthma_eid")
        d <- na.omit(d)
        d <- d[d[,17]>=0,]
        d$bt <-  ifelse(d[,17]==case_code,1,0)
        e <- d[,c(1,1,3:18)]
        names(e)[2] <- "FID"
        fwrite(d,paste(name,"_dis_raw.txt",sep=""),quote=F,sep='\t',row.names=F,na="NA")

        pheno <- e[,c(1,1,18)]
        names(pheno)[2] <- "IID"
        names(pheno)[3] <- paste0("bt_",traitID)
        cov <- e[,c(1:4,6:16)]
        names(cov)[2] <- "IID"

        fwrite(pheno,paste(name,'_dis.pheno',sep=""),quote=F,sep='\t',row.names=F,na="NA")
        fwrite(cov,paste(name,'_dis.cov',sep=""),quote=F,sep='\t',row.names=F,na="NA")
}else if(action == "--ob"){
        names(c)[1] <- "FID"
        d <- left_join(a,c,by="FID")
        d <- na.omit(d)
        d <- d[d[,17]>=0,]
        d$bt <-  ifelse(d[,17]==case_code,1,0)
        e <- d[,c(1,1,3:18)]
        names(e)[2] <- "IID"
        fwrite(e,paste(name,'_dis_raw.txt',sep=""),quote=F,sep='\t',row.names=F,na="NA")

        pheno <- e[,c(1,1,18)]
        names(pheno)[2] <- "IID"
        names(pheno)[3] <- paste0("bt_",traitID)
        cov <- e[,c(1:4,6:16)]
        names(cov)[2] <- "IID"
        fwrite(pheno,paste(name,'_dis.pheno',sep=""),quote=F,sep='\t',row.names=F,na="NA")
        fwrite(cov,paste(name,'_dis.cov',sep=""),quote=F,sep='\t',row.names=F,na="NA")
}
else{print("option error")}
        
