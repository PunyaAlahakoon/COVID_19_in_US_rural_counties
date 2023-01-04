library(R.matlab)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(ggthemes)
#library(wesanderson)
#library(RColorBrewer)
library(colorspace)
library(lubridate)

library(readr)
library(grid)
library(gridExtra)
library(GGally)

library(psych)


st_days=c(154,150,152,176,129,135);
k=1

#read observed data:
cases=read.csv("case_numbers.csv",header = T)
cases1=cases[st_days[k]:446,c(1,2)]
cases1=data.frame(cases1,rep("Miner, SD",length(cases1$Date)))

cases1$Date=as.Date(mdy(cases1$Date))
colnames(cases1)<-c("Date","cases","County")

#load original paths:
MINER_case_paths=readMat("MINER_case_paths.mat")
MINER_case_paths=MINER_case_paths$predicted.case.paths
MINER_case_paths=data.frame("Date"=cases1$Date, MINER_case_paths)
MINER_case_paths=data.frame(melt(MINER_case_paths,id="Date"),"County"=rep("Miner, SD",length(cases1$Date)*1000))


k=2

#read observed data:

cases2=cases[st_days[k]:446,c(1,5)]
cases2=data.frame(cases2,rep("Buffalo, SD",length(cases2$Date)))

cases2$Date=as.Date(mdy(cases2$Date))
colnames(cases2)<-c("Date","cases","County")

#load original paths:
BUFFALO_case_paths=readMat("BUFFALO_case_paths.mat")
BUFFALO_case_paths=BUFFALO_case_paths$predicted.case.paths
BUFFALO_case_paths=data.frame("Date"=cases2$Date, BUFFALO_case_paths)
BUFFALO_case_paths=data.frame(melt(BUFFALO_case_paths,id="Date"),"County"=rep("Buffalo, SD",length(cases2$Date)*1000))


k=3

#read observed data:
cases3=cases[st_days[k]:446,c(1,6)]
cases3=data.frame(cases3,rep("Faulk, SD",length(cases3$Date)))

cases3$Date=as.Date(mdy(cases3$Date))
colnames(cases3)<-c("Date","cases","County")

#load original paths:
FAULK_case_paths=readMat("FAULK_case_paths.mat")
FAULK_case_paths=FAULK_case_paths$predicted.case.paths
FAULK_case_paths=data.frame("Date"=cases3$Date, FAULK_case_paths)
FAULK_case_paths=data.frame(melt(FAULK_case_paths,id="Date"),"County"=rep("Faulk, SD",length(cases3$Date)*1000))


k=4

#read observed data:

cases4=cases[st_days[k]:446,c(1,8)]
cases4=data.frame(cases4,rep("Towner, ND",length(cases4$Date)))

cases4$Date=as.Date(mdy(cases4$Date))
colnames(cases4)<-c("Date","cases","County")

#load original paths:
TOWNER_case_paths=readMat("TOWNER_case_paths.mat")
TOWNER_case_paths=TOWNER_case_paths$predicted.case.paths
TOWNER_case_paths=data.frame("Date"=cases4$Date, TOWNER_case_paths)
TOWNER_case_paths=data.frame(melt(TOWNER_case_paths,id="Date"),"County"=rep("Towner, ND",length(cases4$Date)*1000))


k=5

#read observed data:

cases5=cases[st_days[k]:446,c(1,10)]
cases5=data.frame(cases5,rep("Eddy, ND",length(cases5$Date)))

cases5$Date=as.Date(mdy(cases5$Date))
colnames(cases5)<-c("Date","cases","County")

#load original paths:
EDDY_case_paths=readMat("EDDY_case_paths.mat")
EDDY_case_paths=EDDY_case_paths$predicted.case.paths
EDDY_case_paths=data.frame("Date"=cases5$Date, EDDY_case_paths)
EDDY_case_paths=data.frame(melt(EDDY_case_paths,id="Date"),"County"=rep("Eddy, ND",length(cases5$Date)*1000))

k=6

#read observed data:

cases6=cases[st_days[k]:446,c(1,11)]
cases6=data.frame(cases6,rep("Golden Valley, ND",length(cases6$Date)))

cases6$Date=as.Date(mdy(cases6$Date))
colnames(cases6)<-c("Date","cases","County")

#load original paths:
GOLDEN_case_paths=readMat("GOLDEN_case_paths.mat")
GOLDEN_case_paths=GOLDEN_case_paths$predicted.case.paths
GOLDEN_case_paths=data.frame("Date"=cases6$Date,GOLDEN_case_paths)
GOLDEN_case_paths=data.frame(melt(GOLDEN_case_paths,id="Date"),"County"=rep("Golden Valley, ND",length(cases6$Date)*1000))


lvs=c("Miner, SD","Buffalo, SD","Faulk, SD","Towner, ND", "Eddy, ND", "Golden Valley, ND")
cases_all=rbind(cases1,cases2,cases3,cases4,cases5,cases6,cases6)
cases_all$County=factor(cases_all$County,levels = lvs)

paths=rbind(MINER_case_paths,BUFFALO_case_paths,FAULK_case_paths,TOWNER_case_paths,EDDY_case_paths,GOLDEN_case_paths)
paths$County=factor(paths$County,levels = lvs)

pl=ggplot()+
  geom_line(data=paths,aes(x=Date,y=value,group=variable),color= "#9986A5",alpha=0.25,size=.1)+
  geom_line(data=cases_all,aes(Date,cases),color= "black",alpha=0.8,size=0.5)+
  facet_wrap(~County,ncol = 3)+
  # geom_vline(data=NULL,aes(xintercept=as.numeric(dat[14])), linetype="dotted", color="black", size=0.5)+
  ylab("New infections")+
 ylim(0,38)+
  theme_minimal(14) +
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 14))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())
pl


ggsave("all_predictions.png",last_plot(),height = 8,width = 12)
