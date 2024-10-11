
%sample parameters with hierarchy and for other params, without hierarchy 


function[params]=priors_hie3(hb,hb_sig,cor)

params=zeros(6,15);
n=6; %number of counties to consider 
%B=1000; %number of posterior samples in the independent step 

%lower levels for tau tau*gamma1 gamma2
lw=[0 0 ];

%upper levels for betas:
up=[2 2];
%up=[20 10 10 15 010]; %for testing 

%correlation matrix:
ro=reshape(cor,2,2);
ss=diag(hb_sig);
sigma=ss*ro*ss;





%alpha, delta*omega, epsilon 1, 2, d are identical
%from pars 6;11, 13 perrturb:
   in_par=[6:10 15];

t_a=lognrnd(0.4039,0.6); %mode=1.5 days 
priors6=1/t_a;


t_e=lognrnd(1.125,0.35); %mean ~~3.275 days 
%rates:
omega=1/t_e;
priors7=omega;

%A1+A2:
t_aa1=lognrnd(0.6619,0.25,1,1); %var was 0.5!! 
priors8=1./t_aa1;

t_aa2=lognrnd(-0.3,0.5,1,1); %var was 0.5!! 
priors9=1./t_aa2;

%presymtomatic:P->I
t_ps=lognrnd(0.635,0.35); %on average 2 days 
%rates:
priors10=1/t_ps; 

priors15=betarnd(1.5,30); %death rate 

all_pars=[priors6 priors7 priors8 priors9 priors10 priors15];

params(:,in_par)=repmat(all_pars,n,1);


%assume b, transmissions, are county specific are different across counties 
for i=1:n
   % cou_ind=[1:5 12 14];
    params(i,4)=unifrnd(0.0000001,0.05,1,1);
    params(i,5)=unifrnd(0.0000001,0.1,1,1);

%S-E :par(1)
params(i,1)=unifrnd(0.00001,2,1,1);

%V1-E, V2-E: par(2:3)
params(i,2:3)=unifrnd(0.0001,1,1,2);

%tau: 
tau=unifrnd(0.00001,1);
params(i,12)=tau; 

params(i,14)=unifrnd(0,2); %re-introduce infection remeber to change this with county number!!

end


for i=1:n
    betax=zeros(1,2);
    while ~(all(betax>lw,'all') && all(betax<up,'all'))
    betax= mvnrnd(hb,sigma,1);
    end
    gamma1=betax(1)/params(i,12); gamma3=betax(2);
    params(i,[11 13])=[gamma1 gamma3];
end

end