k=10; %population to consider 
%load pop sizes:
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);
N=pop_N(k); %initial population size 

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));
%load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));
st_days=load("dt.mat","de");
st_days=st_days.de;

    cases=y(st_days(k):end,k);
    deaths=ds(st_days(k):end,k); 
%which rates to count 
count=[11 16 17 1 2]; 
%11=  infections 16, 17= deaths 1= dose 1, 2= dose2 

 %vaccine date:
 vim=zeros(14,12); %shift the vaccinations to 14 days 
vt1=readtable("dose1_time_series.csv");
vv1=table2array(vt1(:,2:13));
v1=[vim;vv1(1:end-14,:)];
vt2=readtable("dose2_time_series.csv");
vv2=table2array(vt2(:,2:13));
v2=[vim;vv2(1:end-14,:)];


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

T=times(end);
t=times(2):times(end); %vaccination time period to consider 
par=para_smc{1,k};

M=1; %how many times to repeat the parameter set, i.e., how many paths per par set?
paras=repmat(par,M,1);

B=size(paras,1); %number of terations to run 

%store predictions 
predicted_case_paths=zeros(T,B);
predicted_total_deaths=zeros(1,B); 
predicted_dose1_paths=zeros(T,B);%NOT the moving averages. chack that later 
predicted_dose2_paths=zeros(T,B);%NOT the moving averages. chack that later


parfor i=1:B
par=paras(i,:);
 [~,daily_c,inci]=sample_generator_null_model2(times,par,N,count);
  predicted_case_paths(:,i)=daily_c(:,1);
  predicted_total_deaths(:,i)=sum(inci(end,2:3));
  predicted_dose1_paths(:,i)=daily_c(:,4);
  predicted_dose2_paths(:,i)=daily_c(:,5);
   

end
save('predicted_case_paths.mat','predicted_case_paths')
save('predicted_total_deaths.mat','predicted_total_deaths')
save('predicted_dose1_paths.mat','predicted_dose1_paths')
save('predicted_dose2_paths.mat','predicted_dose2_paths')


