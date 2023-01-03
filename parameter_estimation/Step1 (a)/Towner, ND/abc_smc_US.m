%run this for all the counties.  
tic

%load a vetor to specify which day to start the epidemic for parameter
%estimation 
st_days=load("dt.mat","de");
st_days=st_days.de;

%load county population sizes:
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));

%load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));



 %vaccine date:
 vim=zeros(14,12); %shift the vaccinations to 14 days 
vt1=readtable("dose1_time_series.csv");
vv1=table2array(vt1(:,2:13));
v1=[vim;vv1(1:end-14,:)];
vt2=readtable("dose2_time_series.csv");
vv2=table2array(vt2(:,2:13));
v2=[vim;vv2(1:end-14,:)];




 dim=size(y,2); %number of counties to consider 

%Number of particles/ parameters sets to sample using ABC-SMC
B=1000;

%number of generations to run:
G=4;

count=[11 16 17 1 2];%these are the same for all teh counties 
%counts=[11=daily_notified cases 15:17=deaths 4=dose 1 5=dose2]

%store parameters:
np=15; %number of parameters to estimate 
para_smc={1,dim};
sx={1,dim};
accepted_case_paths={1,dim};
accepted_dose1_paths={1,dim};
accepted_dose2_paths={1,dim};
w_smc=zeros(B,dim); % store weights

%Es=Es';
AG_smc=zeros(G,dim);%store the # of particles generated to get B parameters(if needed) 
s_x= zeros(B,dim);%save the distance criteria (if needed)

for k=7:7
    %input data:
    N=pop_N(k); %initial population size 
   % ind=find(isnan(y(st_days(k):end,k))); in=1; Don't need this anymore:
   % start days are different for counties 
    cases=y(st_days(k):end,k); deaths=ds(st_days(k):end,k); 
    
    %vaccine first dose availbility: depends on states SD:12/15/2020 ND: 12/14/2020
   if ismember(k,1:6) %SD; k=1:6
        vi=264-st_days(k);  %264 is the day of vaccine availbility out of original time frame 
   else
        vi=263-st_days(k);
   end

    %vaccines=[v1(vi:end,k) v2(vi:end,k)]; %there are NaNs at the end! check with distance metrics 
    %vaccines=[v1(:,k) v2(:,k)];
    %find the day to start the vaccine time-series: 
    vcc1=(v1(st_days(k):end,k)); vcc2= (v2(st_days(k):end,k));
    ind=[find(isnan(vcc1), 1, 'last' ) find(isnan(vcc2), 1, 'last' )]; 
    cv=[find(vcc1(ind(1)+1:end)~=0,1,'first')+ind(1) find(vcc2(ind(2)+1:end)~=0,1,'first')+ind(2)];
    %cv(1) and cv(2) are the same for both doses
    
    vaccines=[[zeros(cv(1),1); movmean(vcc1(cv(1)+1:end),7)] [zeros(cv(2),1); movmean(vcc2(cv(2)+1:end),7)]];
    vacc_cum=[vcc1(cv(1)) vcc2(cv(2))];

    times=[0 vi cv(1)+1 length(cases)];
    %times: to when to start the dose 1, dose 2: relative to case occurance
    
    %load pre-defined tolerance vaues depending on the population:
    E=load(['E_' num2str(k) '.mat']);
    % Es=load('Es'); %load tolerance values 
    E=E.E;
    e=E(1,:);
    %set a counter for number of iterations to run for each gen 
    AG=zeros(1,G);

    %store parameter sets
    params=zeros(B,np);
    w=zeros(1,B); %store weights 
    %es=zeros(G+1,4);
     case_paths=zeros(length(cases),B);
    dose1_paths1=zeros(length(cases),B);
    dose2_paths1=zeros(length(cases),B);
    es(1,:)=e;
    g=1;

    while (g<1+G) %number of generation 
    %store values for the current generation
    params0=zeros(B,np);
    w0=zeros(1,B); %store weights 
    ag=0;%set the counter 
    ag0=zeros(1,B);%set the counter 
    rho_m=zeros(B,7);%store the distance values 
    accepted_case_paths0=zeros(length(cases),B);
    dose1_paths0=zeros(length(cases),B);
    dose2_paths0=zeros(length(cases),B);
     parfor a=1:B %particle number     
     [params0(a,:),w0(a),rho_m(a,:),ag0(a),accepted_case_paths0(:,a),...
         dose1_paths0(:,a),dose2_paths0(:,a)]=abc_ind_step(g,B,params,w,cases,deaths,vaccines,vacc_cum,e,count,times,N);
     end 
        
       % e=E(g+1);
        %e=median(rho_m);
         e=E(g+1,:);
      % es(g+1)=e;
        %normalize the weights 
        w0=normalize(w0,'norm',1);
        %replecae the previous gen values from the new gen values
        params=params0;
        w=w0; %store weights 
        AG(g)=sum(ag0);
        case_paths=accepted_case_paths0;
        dose1_paths1=dose1_paths0;
        dose2_paths1=dose2_paths0;
        g=g+1 %update the generation number 
    end
%store the final values for the counties:
para_smc{1,k}=params;
w_smc(:,k)=w; %weights 
%E_smc(:,k)=es;%tolerance values 
AG_smc(:,k)=AG;%number of steps generated to get B parameters 
sx{1,k}= rho_m;
accepted_case_paths{1,k}=case_paths; 
accepted_dose1_paths{1,k}=dose1_paths1;
accepted_dose2_paths{1,k}=dose2_paths1;
end

save('para_Towner.mat','para_smc')
save('case_paths_Towner.mat',"accepted_case_paths")
save('dose1_paths_Towner.mat',"accepted_dose1_paths")
save('dose2_paths_Towner.mat',"accepted_dose2_paths")
save('w_smc_Towner.mat','w_smc')
save('AG_smc_Towner.mat','AG_smc')
save('sx_Towner.mat','sx')

toc
