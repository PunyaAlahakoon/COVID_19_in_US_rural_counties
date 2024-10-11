%run this for all the counties.  
tic
%read ind_posteriors:

faulk=load('para_ind_Faulk.mat');
faulk=faulk.para_smc;
faulk=faulk{1,5};

cc=[1 4 5 7 9 10]; % the county to conside

%Say whichever the county you want to load 
ind_pars=faulk;

%load a vetor to specify which day to start the epidemic for parameter
%estimation 
%miner buffalo faulk towner eddy goden_valley 
st_days=[154 150 152 176 129 135];

%load county population sizes:
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);
pop_N=pop_N(cc);

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));
  y=y(:,cc);

%load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));
ds=ds(:,cc);


 %vaccine date:
 vim=zeros(14,12); %shift the vaccinations to 14 days 
vt1=readtable("dose1_time_series.csv");
vv1=table2array(vt1(:,2:13));
v1=[vim;vv1(1:end-14,:)];
v1=v1(:,cc);

vt2=readtable("dose2_time_series.csv");
vv2=table2array(vt2(:,2:13));
v2=[vim;vv2(1:end-14,:)];
v2=v2(:,cc);


%read the hyper parameters fro m7000 to 27000. Take every 2nd value 
%load hyper parameters
hbs=readtable('hb7.csv');
hbs=table2array(hbs);
hbs=hbs(10001:50000,:); %burn-in 
hbs=hbs(1:40:end,2:end); %take every 20th elemnet 

hb_sigs=readtable('hb_sig7.csv');
hb_sigs=table2array(hb_sigs);
hb_sigs=hb_sigs(10001:50000,:); %burn-in 
hb_sigs=hb_sigs(1:40:end,2:end); %take every 2nd elemnet 


ross=readtable('ros7.csv');
ross=table2array(ross);
ross=ross(10001:50000,:); %burn-in 
ross=ross(1:40:end,2:end); %take every 2nd element0

w_smc=load("all_w_smc.mat");
w_smc=w_smc.w_smc;

 dim=size(y,2); %number of counties to consider 

%Number of particles/ parameters sets to sample using ABC-SMC
B=1000;



count=[11 16 17 1 2];%these are the same for all teh counties 
%counts=[11=daily_notified cases 15:17=deaths 4=dose 1 5=dose2]

%store parameters:
np=15; %number of parameters to estimate 


k=3; %COUNTY TO CONSIDER 

    %input data:
    N=pop_N(k); %initial population size 
   % ind=find(isnan(y(st_days(k):end,k))); in=1; Don't need this anymore:
   % start days are different for counties 
    cases=y(st_days(k):end,k); deaths=ds(st_days(k):end,k); 
    
    %vaccine first dose availbility: depends on states SD:12/15/2020 ND: 12/14/2020
  if ismember(k,1:6) %SD; k=1:6
        vi=(264+14)-st_days(k);  %264 is the day of vaccine availbility out of original time frame 
   else
        vi=(263+14)-st_days(k);
   end

    %vaccines=[v1(vi:end,k) v2(vi:end,k)]; %there are NaNs at the end! check with distance metrics 
    %vaccines=[v1(:,k) v2(:,k)];
    %find the day to start the vaccine time-series: 
    vcc1=(v1(st_days(k):end,k)); vcc2= (v2(st_days(k):end,k));
    ind=[find(isnan(vcc1), 1, 'last' ) find(isnan(vcc2), 1, 'last' )]; 
    cv=[find(vcc1(ind(1)+1:end)~=0,1,'first')+ind(1) find(vcc2(ind(2)+1:end)~=0,1,'first')+ind(2)];
    %cv(1) and cv(2) are the same for both doses
    
    %vaccines=[[zeros(cv(1),1); movmean(vcc1(cv(1)+1:end),7)] [zeros(cv(2),1); movmean(vcc2(cv(2)+1:end),7)]];
    vaccines=[[zeros(cv(1),1); vcc1(cv(1):end)] [zeros(cv(2),1); vcc2(cv(2):end)]];

    vacc_cum=[vcc1(cv(1)) vcc2(cv(2))];

 
    times=[0 vi cv(1)+1 length(cases)];
    %times: to when to start the dose 1, dose 2: relative to case occurance
    
    %load pre-defined tolerance vaues depending on the population:
    E=load('E_all.mat');
    % Es=load('Es'); %load tolerance values 
    E=E.B;
    e=E(k,:);

   % e=repmat(1000,1,7); %for testing 
  

     w=w_smc(:,k);
    

    params=zeros(B,np);
    ag=zeros(1,B);%set the counter 
    rho_m=zeros(B,8);%store the distance values 
    accepted_case_paths=zeros(length(cases),B);
    dose1_paths=zeros(length(cases),B);
    dose2_paths=zeros(length(cases),B);

     parfor a=1:B %particle number     
     [params(a,:),rho_m(a,:),ag(a),accepted_case_paths(:,a),...
         dose1_paths(:,a),dose2_paths(:,a)]=abc_ind_step(hbs(a,:),hb_sigs(a,:),ross(a,:),ind_pars,w,cases,deaths,vaccines,vacc_cum,e,count,times,N,k);
     a
     end 
        


   
  %store the final values for the counties:
save("hie_params_FAULK.mat","params");
save('accepted_case_paths_FAULK.mat',"accepted_case_paths");
save("dose1_paths1_FAULK.mat","dose1_paths");
save("dose2_paths1_FAULK.mat","dose2_paths");
save("ag_FAULK.mat","ag");
save("rho_m_FAULK.mat",'rho_m');





toc
