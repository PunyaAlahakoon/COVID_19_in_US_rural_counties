k=1;

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

  %input data:
    N=pop_N(k); %initial population size 
   % ind=find(isnan(y(st_days(k):end,k))); in=1; Don't need this anymore:
   % start days are different for counties 
    cases=y(st_days(k):end,k); deaths=ds(st_days(k):end,k); 
    
    %vaccine first dose availbility: depends on states SD:12/15/2020 ND: 12/14/2020
   if ismember(k,1:6) %SD; k=1:6
        vi=264+14-st_days(k);  %264 is the day of vaccine availbility out of original time frame 
   else
        vi=263+14-st_days(k);
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

    vacc_cum=[sum(vaccines(:,1)) sum(vaccines(:,2))];

    times=[0 vi cv(1)+1 length(cases)];
    %times: to when to start the dose 1, dose 2: relative to case occurance
    

count=[11 16 17 1 2];
%counts=[11=daily_notified cases 15:17=deaths 4=dose 1 5=dose2]

    params=prior_null2(16);



tic
[prev,daily_c,inci]=sample_generator_null_model2(times,params,N,count);
toc

plot(daily_c(:,1))
hold on 
%plot(v1(:,k))
%hold off 
%plot(sum(daily_c(:,2:3),2))
plot(cases)
hold off 