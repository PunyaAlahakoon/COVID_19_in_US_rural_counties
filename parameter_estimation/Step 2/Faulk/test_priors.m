%E-A1; par(6)
t_a=lognrnd(0.4039,0.6); %mode=1.5 days 
params(:,6)=repmat(1/t_a,n,1);

%A1+A2:
t_aa1=lognrnd(0.6619,0.25,1,1); %var was 0.5!! 
params(:,8)=repmat(1./t_aa1,n,1);

t_aa2=lognrnd(-0.3,0.5,1,1); %var was 0.5!! 
params(:,9)=repmat(1./t_aa2,n,1);

t_e=lognrnd(1.125,0.35); %mean ~~3.275 days 
%rates:
omega=1/t_e;
params(:,7)=repamat(omega,n,1);

%presymtomatic:P->I
t_ps=lognrnd(0.635,0.35); %on average 2 days 
%rates:
params(:,10)=repmat(1/t_ps,n,1); 


%I1-> C :symptom onset to getting notified --upto 4 day delay, mean 5 day 
t_c=lognrnd(1.485,0.5); 
alpha_s=1/(t_c*(tau));
params(:,11)= repmat(alpha_s,n,1); %I_p -> I_s::

%symptomatic infectious period: C->R
t_s=lognrnd(1.485,0.5); %consider 0.5 var 
params(:,13)=repmat(1/t_s,n,1); %C->R
