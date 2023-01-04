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


library(HDInterval)



faulk=readMat("hie_params_FAULK.mat")
faulk=faulk$params
faulk=faulk[,c(1,12)]



eddy=readMat("hie_params_EDDY.mat")
eddy=eddy$params
eddy=eddy[,c(1,12)]



dat=rbind(faulk,eddy)

County=c(rep("Faulk, SD",1000),rep("Eddy, ND",1000))


colnames(faulk)=colnames(eddy)=c("beta","tau")
dat=data.frame(dat,County)


hie_paras<-ggpairs(dat, columns = 1:2,
                   diag = list(continuous = wrap("densityDiag", alpha=0.8)),
                   upper = list(continuous =wrap( "density", alpha = 0.8)),
                   lower = list(combo = wrap("facethist", bins = 100, alpha = 0.8)), legend = 1,
                   ggplot2::aes(colour=County))+
  theme_minimal(14) +
  scale_fill_manual(values= c("#D69C4E" ,"#046C9A" ))+
  scale_color_manual(values= c("#D69C4E","#046C9A" ))+
 #ylim(0,10)+
  theme(axis.text=element_text(size=14),
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_text(size = 12))+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())

hie_paras

#ggsave("eddy_faulk_posterior.png",last_plot(),height = 8,width = 8)

hdi(faulk)
median(faulk[,2])

hdi(eddy)
median(eddy[,2])
