
%generate parameters from the prior distributions for the null model
%number of states= 12, start with one exposed person 

function[priors]=prior_null(n)
priors=zeros(1,n);

%S-V1; V1-V2: par(4:5)
priors(4)=unifrnd(0.0000001,0.05,1,1);
priors(5)=unifrnd(0.0000001,0.1,1,1);

%S-E :par(1)
priors(1)=unifrnd(0.00001,1.5,1,1);

%V1-E, V2-E: par(2:3)
priors(2:3)=unifrnd(0.0001,1,1,2);

%E-A1; par(6)
t_a=lognrnd(0.4039,0.6); %mode=1.5 days 
priors(6)=1/t_a;

%A1+A2:
t_aa1=lognrnd(0.6619,0.25,1,1); %var was 0.5!! 
priors(8)=1./t_aa1;

t_aa2=lognrnd(-0.3,0.5,1,1); %var was 0.5!! 
priors(9)=1./t_aa2;

tT=-1;
t_2=-1;
while (tT<=0) || (t_2<=0)


% symptomatic exposure: E -> P
%taking Exposure~lognormal(0.4080,0.05^2), mode(Exposure)=1.5 days 
%t_e=lognrnd(0.4080,0.05,g,1);
t_e=lognrnd(0.75,0.25); %mean ~~3.8 days 
%rates:
omega=1/t_e;
priors(7)=omega;

%Incubation period: E->P->I: lognormal--mean 5.8 days pars(7+10)
t_i=lognrnd(0.75,0.25);
%presymtomatic:P->I
t_ps=t_i-t_e;
t_2=t_ps;
%rates:
priors(10)=1/t_ps; 



%tau: 
tau=unifrnd(0.00001,1);
priors(12)=tau; 

%I1-> C :symptom onset to getting notified --upto 4 day delay, mean 1 day 
t_c=lognrnd(-1,0.5); 
alpha_s=1/(t_c*(tau));
priors(11)= alpha_s; %I_p -> I_s::

%seriel interval, T: exposure, pre-symtomatic, and infectious period 
%taking T~lognormal(1.6086,0.04^2), E(T)=5.02 days , mode=5 days 
%t=lognrnd(1.6110,0.04,g,1);
t=lognrnd(1.5,0.5);%consider 0.5 var 

%symptomatic infectious period: C->R
t_s=t-t_i-t_c;
%I_p -> M:: 
%t_m=t(2)-t_e-t_s;
tT=t_s;

priors(13)=1/t_s; %C->R
priors(14)=unifrnd(0,0.6); %re-introduce infection 

priors(15)=betarnd(1.5,30); %death rate 

end


end