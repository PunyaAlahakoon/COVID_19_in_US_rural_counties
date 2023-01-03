
%sample parameters with hierarchy and for other params, without hierarchy 


function[params]=priors_hie2(hb,hb_sig,cor,ind_pars,w)

params=zeros(1,15);
%n=6; %number of counties to consider 
B=1000; %number of posterior samples in the independent step 

%lower levels for tau tau*gamma1 gamma2
lw=[0.00001 0.00001];

%upper levels for betas:
up=[1 2];
%up=[20 10 10 15 010]; %for testing 

%correlation matrix:
ro=reshape(cor,2,2);
ss=diag(hb_sig);
sigma=ss*ro*ss;


    betax=zeros(1,2);
    while ~(all(betax>lw,'all') && all(betax<up,'all'))
    betax= mvnrnd(hb,sigma,1);
    end
    
    params([12 1])=betax;

%asssume every other parameter is county specific:

    cou_ind=[2:11 13:15];
    
    ind_pp=ind_pars(:, cou_ind);
    ind=randsample(1:B,1,true,w);
    par0=ind_pp(ind,:);
    ss=std(ind_pp);
    params(cou_ind)=abs(normrnd(par0,ss));



end