
%sample parameters with hierarchy and for other params, without hierarchy 


function[params]=priors_hie(hb,hb_sig,cor,ind_pars,w_smc)

params=zeros(6,15);
n=6; %number of counties to consider 
B=1000; %number of posterior samples in the independent step 

%lower levels for betas:
lw=[0.00001 0.0001 0.0001 0.0000001 0.0000001 0.00001];

%upper levels for betas:
up=[2 1 1 0.05 0.1 1];
%up=[20 10 10 15 010]; %for testing 

%correlation matrix:
ro=reshape(cor,6,6);
ss=diag(hb_sig);
sigma=ss*ro*ss;


for i=1:n
    betax=zeros(1,6);
    while ~(all(betax>lw,'all') && all(betax<up,'all'))
    betax= mvnrnd(hb,sigma,1);
    end
    params(i,[1:5 12])=betax;
end
%params(:,1:5)=betas;


%from pars 6;11, 13 perrturb:
  w= reshape(w_smc,1,[]);
  ind=randsample(1:6000,1,true,w);
  par0=ind_pars(ind,[6:11 13 15]);
  ss=std(ind_pars(:,[6:11 13 15]));
  par=abs(normrnd(par0,ss));

params(:,[6:11 13 15])=repmat(par,n,1);

%assume par 12, 14, 15 are different across counties 
for i=1:n
    range=1+(B*(i-1)):(B*i); % county range 1:1000, 1001:2000, 2001:3000 etc
    ind_pp=ind_pars(range, 14);
    ind=randsample(1:B,1,true,w_smc(:,i));
    par0=ind_pp(ind,:);
    ss=std(ind_pp);
    params(i,14)=abs(normrnd(par0,ss));
end



end