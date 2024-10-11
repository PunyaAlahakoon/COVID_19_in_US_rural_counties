
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));

 %load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));

 %vaccine date:
vt1=readtable("dose1_time_series.csv");
v1=table2array(vt1(:,2:13));
vt2=readtable("dose2_time_series.csv");
v2=table2array(vt2(:,2:13));

k=1;

 N=pop_N(k); %initial population size 
    ind=find(isnan(y(:,k))); in=ind(end)+1; %data starts from day in where the first case was observed 
    cases=y(in:end,k); deaths=ds(in:end,k); 
    
    %vaccine availbility: depends on states SD:12/15/2020 ND: 12/14/2020
    if ismember(k,1:6) %SD; k=1:6
        vi=264;
    else
        vi=263;
    end

    vaccines=[v1(vi:end,k) v2(vi:end,k)]; %there are NaNs at the end! check with distance metrics 
    times=[0 vi-in length(cases)];
    %times: to when to start the dose 1, dose 2: relative to case occurance
    

count=[11 16 17 18 1 2];
%counts=[11=daily_notified cases 15:17=deaths 4=dose 1 5=dose2]

    params=prior_null(15);



tic
[prev,daily_c,inci]=sample_generator_null_model2(times,params,N,count);
toc

plot(daily_c(:,5))