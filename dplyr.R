f<-factor(c(3.4, 1.2, 5))
class(f)
f<-levels(f)[f]
class(f)
f<-as.numeric(f)
class(f)
as.POSIXlt("1980-09-30 10:11:12")$year+1900
as.POSIXlt("1980-09-30 10:11:12")$mon+1
as.POSIXlt("1980-09-30 10:11:12")$mday
unlist(as.POSIXlt("1980-09-30 10:11:12"))

library(dplyr)
options(width=105)
chicago<-readRDS("./data/chicago.rds")
dim(chicago)
str(chicago)
names(chicago)
head(select(chicago, city:dptp))
head(select(chicago, -(city:dptp)))     

i<-match("city", names(chicago))
j<-match("dptp", names(chicago))
head(chicago[,-(i:j)])

chic.f<-filter(chicago, pm25tmean2 >30)
head(chic.f, 10)
chic.f<-filter(chicago, pm25tmean2>30 & tmpd>80)
head(chic.f)

arrange(chicago, date)
arrange(chicago, desc(date))

chicago<-rename(arrange(chicago, desc(date)), pm25=pm25tmean2, dewpoint=dptp)

chicago<-mutate(chicago, pm25detrend=pm25-mean(pm25, na.rm=TRUE))
head(select(chicago2, pm25, pm25detrend))

chicago<- mutate(chicago, tempcat=factor(tmpd>80, labels = c("cold","hot")))
chicago
hotcold<-group_by(chicago, tempcat)
hotcold
summarize(hotcold, pm25=mean(pm25, na.rm=T), o3=max(o3tmean2), no2=median(no2tmean2))

chicago<-mutate(chicago, year=as.POSIXlt(date)$year+1900)
chicago
year<-group_by(chicago, year)
year
summarize(year, pm25=mean(pm25, na.rm=T), o3=max(o3tmean2), no2=median(no2tmean2))

chicago %>% mutate(month = as.POSIXlt(date)$mon+1) %>% group_by(month) %>% 
  summarize(pm25=mean(pm25, na.rm=T), o3=max(o3tmean2), no2=median(no2tmean2))