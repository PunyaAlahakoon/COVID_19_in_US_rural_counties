%run this for all the counties.  
tic
%read ind_posteriors:
count=[11 16 17 1 2];%these are the same for all teh counties 

buffalo=load('hie_params_BUFFALO.mat');
buffalo=buffalo.params;

cc=[1 4 5 7 9 10]; % the county to conside

%Say whichever the county you want to load 
pars=buffalo;
k=2;

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
   if ismember(k,1:3) %SD; k=1:6
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


M=1; %how many times to repeat the parameter set, i.e., how many paths per par set?
paras=repmat(pars,M,1);

B=size(paras,1); %number of terations to run 

%store predictions 
predicted_case_paths=zeros(T,B);
predicted_total_deaths=zeros(1,B); 

%2 weeks 
case_paths_2W_20=zeros(T,B);
total_deaths_2W_20=zeros(1,B); 

case_paths_2W_60=zeros(T,B);
total_deaths_2W_60=zeros(1,B); 

case_paths_2W_80=zeros(T,B);
total_deaths_2W_80=zeros(1,B); 

%1 month 
case_paths_4W_20=zeros(T,B);
total_deaths_4W_20=zeros(1,B); 

case_paths_4W_60=zeros(T,B);
total_deaths_4W_60=zeros(1,B); 

case_paths_4W_80=zeros(T,B);
total_deaths_4W_80=zeros(1,B); 

%2 months
case_paths_2M_20=zeros(T,B);
total_deaths_2M_20=zeros(1,B); 

case_paths_2M_60=zeros(T,B);
total_deaths_2M_60=zeros(1,B); 

case_paths_2M_80=zeros(T,B);
total_deaths_2M_80=zeros(1,B); 



parfor i=1:B
par=paras(i,:);
 [~,daily_c,inci]=sample_generator_null_model2(times,par,N,count);
 predicted_case_paths(:,i)=daily_c(:,1);
 predicted_total_deaths(i)=sum(inci(end,2:3));

 %after 2 weeks of increasing FOI
[~,daily_2W_20,inci_2W_20]=sample_generator_null_model_x_weeks(times,par,N,count,1.2,14);
case_paths_2W_20(:,i)=daily_2W_20(:,1);
total_deaths_2W_20(i)=sum(inci_2W_20(end,2:3));

[~,daily_2W_60,inci_2W_60]=sample_generator_null_model_x_weeks(times,par,N,count,1.6,14);
case_paths_2W_60(:,i)=daily_2W_60(:,1);
total_deaths_2W_60(i)=sum(inci_2W_60(end,2:3));

[~,daily_2W_80,inci_2W_80]=sample_generator_null_model_x_weeks(times,par,N,count,1.8,14);
case_paths_2W_80(:,i)=daily_2W_80(:,1);
total_deaths_2W_80(i)=sum(inci_2W_80(end,2:3));


 %after 4 weeks of increasing FOI
[~,daily_4W_20,inci_4W_20]=sample_generator_null_model_x_weeks(times,par,N,count,1.2,30);
case_paths_4W_20(:,i)=daily_4W_20(:,1);
total_deaths_4W_20(i)=sum(inci_4W_20(end,2:3));

[~,daily_4W_60,inci_4W_60]=sample_generator_null_model_x_weeks(times,par,N,count,1.6,30);
case_paths_4W_60(:,i)=daily_4W_60(:,1);
total_deaths_4W_60(i)=sum(inci_4W_60(end,2:3));

[~,daily_4W_80,inci_4W_80]=sample_generator_null_model_x_weeks(times,par,N,count,1.8,30);
case_paths_4W_80(:,i)=daily_4W_80(:,1);
total_deaths_4W_80(i)=sum(inci_4W_80(end,2:3));


 %after 2 months of increasing FOI
[~,daily_2M_20,inci_2M_20]=sample_generator_null_model_x_weeks(times,par,N,count,1.2,60);
case_paths_2M_20(:,i)=daily_2M_20(:,1);
total_deaths_2M_20(i)=sum(inci_2M_20(end,2:3));


[~,daily_2M_60,inci_2M_60]=sample_generator_null_model_x_weeks(times,par,N,count,1.6,60);
case_paths_2M_60(:,i)=daily_2M_60(:,1);
total_deaths_2M_60(i)=sum(inci_2M_60(end,2:3));

[~,daily_2M_80,inci_2M_80]=sample_generator_null_model_x_weeks(times,par,N,count,1.8,60);
case_paths_2M_80(:,i)=daily_2M_80(:,1);
total_deaths_2M_80(i)=sum(inci_2M_80(end,2:3));


  %predicted_case_paths(:,i)=daily_c(:,1);
  %predicted_total_deaths(:,i)=sum(inci(end,2:3));
 % predicted_dose1_paths(:,i)=daily_c(:,4);
  %predicted_dose2_paths(:,i)=daily_c(:,5);
  %predicted_dose12_cum_163(:,i)=inci(163,4:5)'; 

end


save('BUFFALO_case_paths.mat','predicted_case_paths')
save('BUFFALO_predicted_total_deaths.mat','predicted_total_deaths')

save('case_paths_2W_20.mat','case_paths_2W_20')
save('total_deaths_2W_20.mat','total_deaths_2W_20')

save("case_paths_2W_60.mat","case_paths_2W_60")
save("total_deaths_2W_60.mat","total_deaths_2W_60")

save("case_paths_2W_80.mat","case_paths_2W_80")
save("total_deaths_2W_80.mat","total_deaths_2W_80")

save("case_paths_4W_20.mat","case_paths_4W_20")
save("total_deaths_4W_20.mat","total_deaths_4W_20")

save("case_paths_4W_60.mat","case_paths_4W_60")
save("total_deaths_4W_60.mat",'total_deaths_4W_60')

save("case_paths_4W_80.mat","case_paths_4W_80")
save("total_deaths_4W_80.mat","total_deaths_4W_80")

save("case_paths_2M_20.mat","case_paths_2M_20")
save("total_deaths_2M_20.mat","total_deaths_2M_20")

save("case_paths_2M_60.mat","case_paths_2M_60")
save("total_deaths_2M_60.mat","total_deaths_2M_60")

save("case_paths_2M_80.mat","case_paths_2M_80")
save("total_deaths_2M_80.mat","total_deaths_2M_80")




%save('predicted_dose12_cum_163.mat','predicted_dose12_cum_163')

toc
