%run this for all the counties.  
tic
%read ind_posteriors:
count=[11 16 17 1 2];%these are the same for all teh counties 

buffalo=load('hie_params_MINER.mat');
buffalo=buffalo.params;

cc=[1 4 5 7 9 10]; % the county to conside

%Say whichever the county you want to load 
pars=buffalo;
k=1;

%load a vetor to specify which day to start the epidemic for parameter
%estimation 
%miner buffalo faulk towner eddy goden_valley 
st_days=[154 150 152 176 129 135];

%load county population sizes:
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);
pop_N=pop_N(cc);
N=pop_N(k);

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));
  y=y(:,cc);

  %load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));
ds=ds(:,cc);


     % start days are different for counties 
    cases=y(st_days(k):end,k); deaths=ds(st_days(k):end,k); 



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


   
    %vaccine first dose availbility: depends on states SD:12/15/2020 ND: 12/14/2020
   if ismember(k,1:6) %SD; k=1:6
        vi=(264+14)-st_days(k);  %264 is the day of vaccine availbility out of original time frame. Add 14 days to account for vaccine dates  
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

T=times(end);
t=times(2):times(end); %vaccination time period to consider 


M=1; %how many times to repeat the parameter set, i.e., how many paths per par set?
paras=repmat(pars,M,1);

B=size(paras,1); %number of terations to run 

%store predictions 
predicted_dose1_paths=zeros(T,B);
predicted_dose2_paths=zeros(T,B); 



parfor i=1:B
par=paras(i,:);
 [~,daily_c,inci]=sample_generator_null_model2(times,par,N,count);


  %predicted_case_paths(:,i)=daily_c(:,1);
  %predicted_total_deaths(:,i)=sum(inci(end,2:3));
 predicted_dose1_paths(:,i)=daily_c(:,4);
  predicted_dose2_paths(:,i)=daily_c(:,5);
  %predicted_dose12_cum_163(:,i)=inci(163,4:5)'; 

end


save('MINER_predicted_dose1_paths.mat','predicted_dose1_paths')
save('MINER_predicted_dose2_paths.mat','predicted_dose2_paths')



toc
