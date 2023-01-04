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




#load data:
#post=readMat("hie_params_MINER.mat")
#post=readMat("hie_params_BUFFALO.mat")
#post=readMat("hie_params_FAULK.mat")
#post=readMat("hie_params_TOWNER.mat")
post=readMat("hie_params_EDDY.mat")
post=readMat("hie_params_GOLDEN.mat")
post=post$params
post=data.frame(post)

#find delta:
#delta.omega:
par7=post$X7

#delta(1-omega)
par6=post$X6

#delta:
del=par6+par7

omga=par7/del

one_omega=par6/del

beta=post$X1

#r_0=beta*(((one_omega)*((1/post$X8)+(1/post$X9))) + (omga*((1/post$X10)+(1/post$X11)+ ((1-post$X12)*(1/(post$X13+post$X15))) +
#                                                        ((post$X12)*(1/(post$X13+post$X15)))) ))

r_golden=beta*(((one_omega)*((1/post$X8)+(1/post$X9))) + (omga*((1/post$X10)+(1/post$X11)+ ((1-post$X12)*(1/(post$X13+post$X15))) )))


r0=data.frame(r_miner,r_buffalo,r_faulk,r_towner,r_eddy,r_golden)

County=c("Miner, SD", "Buffalo, SD", "Faulk, SD","Towner, ND","Eddy, ND","Golden Valley, ND")
colnames(r0)=County

dd=melt(r0)


r0<-ggplot(dd,aes(x=value))+
  facet_wrap(~variable,ncol = 3)+
  geom_histogram(fill= "#01665E",binwidth = 0.02)+
  ylab("")+
  xlim(0,3)+
  xlab(expression(paste(" ",R[0])))+
  theme_minimal(14) +
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_blank())+
       # axis.text.y = element_blank())+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())

r0


r0<-ggplot(dd,aes(x=variable,y=value))+
  geom_violin(fill= "#01665E",color = NA)+
  geom_boxplot(width=0.1, fill="white")+
  ylab(expression(paste(" ",R[0])))+
  xlab("")+
  theme_minimal(14) +
  theme(strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line = element_line(colour = "black"), 
        # axis.title.y=element_blank(),
        strip.text.x = element_text(size = 14),
        strip.text.y = element_blank())+
  # axis.text.y = element_blank())+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position="bottom")  +
  theme(legend.title=element_blank())

r0
  
ggsave("r0_all.png",last_plot(),height = 6, width = 8)
