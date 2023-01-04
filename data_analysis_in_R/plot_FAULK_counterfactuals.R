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
#library(rpgm)

st_days=c(154,150,152,176,129,135);
k=3

#read observed data:
cases=read.csv("case_numbers.csv",header = T)
cases=cases[st_days[k]:446,c(1,6)]

cases$Date=as.Date(mdy(cases$Date))
colnames(cases)<-c("Date","cases")

#load original paths:
FAULK_case_paths=readMat("FAULK_case_paths.mat")
FAULK_case_paths=FAULK_case_paths$predicted.case.paths
FAULK_case_paths=data.frame("Date"=cases$Date, FAULK_case_paths)
FAULK_case_paths=melt(FAULK_case_paths,id="Date")

#two weeks
case_paths_2W_20=readMat("case_paths_2W_20.mat")
case_paths_2W_20=case_paths_2W_20$case.paths.2W.20
case_paths_2W_20=data.frame("Date"=cases$Date,case_paths_2W_20)
case_paths_2W_20=data.frame(melt(case_paths_2W_20,id="Date"), "increase"=rep("20%" ,length(cases$Date)),"time"=rep("Two weeks",length(cases$Date)))

case_paths_2W_60=readMat("case_paths_2W_60.mat")
case_paths_2W_60=case_paths_2W_60$case.paths.2W.60
case_paths_2W_60=data.frame("Date"=cases$Date,case_paths_2W_60)
case_paths_2W_60=data.frame(melt(case_paths_2W_60,id="Date"),"increase"= rep("60%" ,length(cases$Date)),"time"=rep("Two weeks",length(cases$Date)))

case_paths_2W_80=readMat("case_paths_2W_80.mat")
case_paths_2W_80=case_paths_2W_80$case.paths.2W.80
case_paths_2W_80=data.frame("Date"=cases$Date,case_paths_2W_80)
case_paths_2W_80=data.frame(melt(case_paths_2W_80,id="Date"),"increase"= rep("80%" ,length(cases$Date)),"time"=rep("Two weeks",length(cases$Date)))

#one month 
case_paths_4W_20=readMat("case_paths_4W_20.mat")
case_paths_4W_20=case_paths_4W_20$case.paths.4W.20
case_paths_4W_20=data.frame("Date"=cases$Date,case_paths_4W_20)
case_paths_4W_20=data.frame(melt(case_paths_4W_20,id="Date"), "increase"=rep("20%" ,length(cases$Date)),"time"=rep("One month",length(cases$Date)))

case_paths_4W_60=readMat("case_paths_4W_60.mat")
case_paths_4W_60=case_paths_4W_60$case.paths.4W.60
case_paths_4W_60=data.frame("Date"=cases$Date,case_paths_4W_60)
case_paths_4W_60=data.frame(melt(case_paths_4W_60,id="Date"),"increase"= rep("60%" ,length(cases$Date)),"time"=rep("One month",length(cases$Date)))

case_paths_4W_80=readMat("case_paths_4W_80.mat")
case_paths_4W_80=case_paths_4W_80$case.paths.4W.80
case_paths_4W_80=data.frame("Date"=cases$Date,case_paths_4W_80)
case_paths_4W_80=data.frame(melt(case_paths_4W_80,id="Date"), "increase"=rep("80%" ,length(cases$Date)),"time"=rep("One month",length(cases$Date)))

#two months 
case_paths_2M_20=readMat("case_paths_2M_20.mat")
case_paths_2M_20=case_paths_2M_20$case.paths.2M.20
case_paths_2M_20=data.frame("Date"=cases$Date,case_paths_2M_20)
case_paths_2M_20=data.frame(melt(case_paths_2M_20,id="Date"),"increase"= rep("20%" ,length(cases$Date)),"time"=rep("Two months",length(cases$Date)))

case_paths_2M_60=readMat("case_paths_2M_60.mat")
case_paths_2M_60=case_paths_2M_60$case.paths.2M.60
case_paths_2M_60=data.frame("Date"=cases$Date,case_paths_2M_60)
case_paths_2M_60=data.frame(melt(case_paths_2M_60,id="Date"), "increase"=rep("60%" ,length(cases$Date)),"time"=rep("Two months",length(cases$Date)))

case_paths_2M_80=readMat("case_paths_2M_80.mat")
case_paths_2M_80=case_paths_2M_80$case.paths.2M.80
case_paths_2M_80=data.frame("Date"=cases$Date,case_paths_2M_80)
case_paths_2M_80=data.frame(melt(case_paths_2M_80,id="Date"),"increase"= rep("80%" ,length(cases$Date)),"time"=rep("Two months",length(cases$Date)))

all_paths=rbind(case_paths_2W_20,case_paths_2W_60,case_paths_2W_80,case_paths_4W_20,case_paths_4W_60,case_paths_4W_80,
                 case_paths_2M_20,case_paths_2M_60,case_paths_2M_80)

dat=cases$Date

lv1=c("20%","60%","80%")
lv2=c("Two weeks", "One month","Two months")

all_paths$increase=factor(all_paths$increase,levels = lv1)
all_paths$time=factor(all_paths$time,levels = lv2)


day=c(as.numeric(dat[14]),as.numeric(dat[30]),as.numeric(dat[60]))

dat_vlin=data.frame("increase"=rep(lv1,3),"time"=rep(lv2,1,each=3),"value"=rep(day,each=3))

pl=ggplot()+
  geom_line(data=all_paths,aes(Date,value,group=variable),color= "#D69C4E",alpha=0.03,size=.15)+
  geom_line(data=FAULK_case_paths,aes(x=Date,y=value,group=variable),color= "#35274A",alpha=0.01,size=.18)+
  geom_vline(data=dat_vlin,aes(xintercept=value), linetype="dotted", color="black", size=0.5)+
  facet_grid(factor(increase)~factor(time))+
  # geom_line(data=cases,aes(Date,cases),color= "black",alpha=0.8,size=.2)+
  ylab("New infections")+
  ylim(0,60)+
  theme_minimal(14) +
  ggtitle("Faulk, SD")+
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 14))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")

pl


ggsave("Faulk_interventions.png",pl,height = 10,width = 12)
