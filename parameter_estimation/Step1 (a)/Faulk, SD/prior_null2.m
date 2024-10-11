
%generate parameters from the prior distributions for the null model
%number of states= 12, start with one exposed person 

function[priors]=prior_null2(n)
priors=zeros(1,n);

%S-V1; V1-V2: par(4:5)
priors(4)=unifrnd(0.0000001,0.05,1,1);
priors(5)=unifrnd(0.0000001,0.1,1,1);

%S-E :par(1)
priors(1)=unifrnd(0.00001,2,1,1);

%V1-E, V2-E: par(2:3)
priors(2:3)=unifrnd(0.0001,1,1,2);

%E-A1; par(6)
t_a=lognrnd(0.4039,0.8); %mode=1.5 days 
priors(6)=1/t_a;

%A1+A2:
t_aa1=lognrnd(0.6619,0.25,1,1); %var was 0.5!! 
priors(8)=1./t_aa1;

t_aa2=lognrnd(-0.3,0.5,1,1); %var was 0.5!! 
priors(9)=1./t_aa2;




% symptomatic exposure: E -> P
%taking Exposure~lognormal(0.4080,0.05^2), mode(Exposure)=1.5 days 
%t_e=lognrnd(0.4080,0.05,g,1);
t_e=lognrnd(1.125,0.35); %mean ~~3.275 days 
%rates:
omega=1/t_e;
priors(7)=omega;

%presymtomatic:P->I
t_ps=lognrnd(0.635,0.35); %on average 2 days 
%rates:
priors(10)=1/t_ps; 


%tau: 
tau=unifrnd(0.00001,1);
priors(12)=tau; 

%I1-> C :symptom onset to getting notified --upto 4 day delay, mean 5 day 
t_c=lognrnd(1.485,0.5); 
alpha_s=1/(t_c*(tau));
priors(11)= alpha_s; %I_p -> I_s::


%symptomatic infectious period: C->R
t_s=lognrnd(1.485,0.5); %consider 0.5 var 

priors(13)=1/t_s; %C->R

priors(14)=unifrnd(0,2); %re-introduce infection 

priors(15)=betarnd(1.5,30); %death rate 


end