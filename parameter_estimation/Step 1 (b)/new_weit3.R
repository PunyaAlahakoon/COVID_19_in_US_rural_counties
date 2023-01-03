

function(l,u,county,hs,sig){
  
  
  par=cbind(county[,12],county[,1])
  
  pdp=dtmvnorm(par,hs,sig,lower=l,upper=u) 
  
  mume=dunif(par[,1],0.00001,1)*
    dunif(par[,1],0.00001,2)
  
  
  wk=pdp/mume
  sum(wk[wk>0])
}