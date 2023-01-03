
library(tmvtnorm)
library(R.matlab)
library(trialr)

library(MASS)

#spcify starting values for beta gamma mu:
N=50000# %number of MCMC iterations

miner=readMat("para_MINER.mat")
miner=miner$miner

faluk=readMat('para_Faulk.mat')
faluk=faluk$faulk

buffalo=readMat('para_Buffalo.mat')
buffalo=buffalo$buffalo

towner=readMat('para_Towner.mat')
towner=towner$towner

eddy=readMat('para_Eddy.mat')
eddy=eddy$eddy

golden=readMat('para_Golden_Valley.mat')
golden=golden$golden

wetf=dget("new_weit3.R")


#hyper-mean 
#lower levels for all the hyper-parameters:
lw=c(0.00001,0.00001)


#upper level for all the hyepr-parameters 
up=c(1,2)

#sigmas:
ls=rep(0,2)
us=rep(2,2)


#store data
hb=matrix(ncol = 2,nrow=N)
hb_sig=matrix(ncol = 2,nrow = N)

ros=matrix(ncol=2^2,nrow=N)

poste=c()

#initialisation 
hb[1,]=rep(0.01,2)
hb_sig[1,]=rep(0.11,2)

ss=diag(c(hb_sig[1,]),nrow = 2)

R=rlkjcorr(1, 2, eta =2) #correlation matrix 
ros[1,]<-as.vector(R)

sigmat=ss*R*ss
sigmai=sigmat

w=wetf(lw,up,miner,hb[1,],sigmat)*wetf(lw,up,faluk,hb[1,],sigmat)*wetf(lw,up,buffalo,hb[1,],sigmat)*wetf(lw,up,towner,hb[1,],sigmat)*
  wetf(lw,up,eddy,hb[1,],sigmat)*wetf(lw,up,golden,hb[1,],sigmat)

prior=prod(dunif(hb[1,],lw,up))*prod(dunif(hb_sig[1,],ls,us))

poste[1]=w*prior


#run MCMC
for (i in 2:N) {
  #generate means 
  
  #r_b=abs(mvrnorm(1,hb[i-1,],Sigma = 0.008*diag(2)))
  r_b=abs(rnorm(2,hb[i-1,],sd=c(0.05,0.1)))
  
  r_s=abs(rnorm(2,hb_sig[i-1,],sd=c(0.05,0.1)))
  # r_s=abs(mvrnorm(1,hb_sig[i-1,],Sigma = 0.008*diag(2)))
  
  ss=diag(r_s,nrow = 2)
  R=rlkjcorr(1, 2, eta =2) #correlation matrix
  sigmat=ss*R*ss
  
  
  w=wetf(lw,up,miner,r_b,sigmat)*wetf(lw,up,faluk,r_b,sigmat)*wetf(lw,up,buffalo,r_b,sigmat)*wetf(lw,up,towner,r_b,sigmat)*
    wetf(lw,up,eddy,r_b,sigmat)*wetf(lw,up,golden,r_b,sigmat)
  
  prior=prod(dunif(r_b,lw,up))*prod(dunif(r_s,ls,us))
  
  ps=w*prior
  prop=ps/poste[i-1]
  
  alpha=min(1,prop,na.rm=T)
  uu=runif(1)
  
  if (uu<alpha) {
    hb[i,]=r_b
    hb_sig[i,]=r_s
    poste[i]=ps
    ros[i,]=as.vector(R)
  } else{
    hb[i,]=hb[i-1,]
    hb_sig[i,]=hb_sig[i-1,]
    poste[i]=poste[i-1] 
    ros[i,]<-ros[i-1,]
  }
  
  
  
}



plot(1:N,hb[,1], type = "l")
plot(1:N,hb_sig[,1], type = "l")


write.csv(hb,'hb6.csv')
write.csv(hb_sig,'hb_sig6.csv')
write.csv(ros,'ros6.csv')

