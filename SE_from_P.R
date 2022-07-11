library(data.table)
library(dplyr)

a <- fread("meta_GWAS.meta")
a <- a %>% mutate(tval = qt(a$Pvalue/2,df = a$N))

a$SE <- abs(a$BETA/abs(a$tval))


#Confirm

a$New_pvalue <- pnorm(abs(a$BETA/a$SE),lower.tail=F)*2
