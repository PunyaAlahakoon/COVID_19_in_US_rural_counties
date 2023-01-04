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

miner=readMat("hie_params_MINER.mat")
miner=miner$params
miner=miner

buffalo=readMat('hie_params_BUFFALO.mat')
buffalo=buffalo$params
buffalo=buffalo

faulk=readMat("hie_params_FAULK.mat")
faulk=faulk$params
faulk=faulk

towner=readMat("hie_params_TOWNER.mat")
towner=towner$params
towner=towner

eddy=readMat("hie_params_EDDY.mat")
eddy=eddy$params
eddy=eddy

golden=readMat("hie_params_GOLDEN.mat")
golden=golden$params
golden=golden

par_names=c("beta","lambda*(1-zeta[1])","lambda*(1-zeta[2])","nu[1]","nu[2]","delta*(1-omega)",
            "delta*omega","epsilon[1]","epsilon[2]","alpha","gamma[1]","tau","gamma[2]","b","d")

colnames(miner)=colnames(buffalo)=colnames(faulk)=colnames(towner)=colnames(eddy)=colnames(golden)=par_names

par=eddy
dat=melt(par)

pl=ggplot(data = dat,aes(x=value))+
  geom_density(fill="#046C9A")+
  facet_wrap(~(Var2),ncol=3,labeller =label_parsed,scales = "free")+
  theme_minimal() +
  ggtitle("Eddy, ND")+
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
  theme(legend.title=element_blank())+
  ylab("Density")+
  xlab("Parameter space")

pl


ggsave("eddy_post.png",last_plot(),height = 8, width = 6)

