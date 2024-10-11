%observed for Faulk:
m_cases=29; % max(cases)
d_cases= 44; %find(cases==29)
d_epi_start=


B=5000;
%epidemics that took off:
ep=zeros(1,5000);
ep_t=zeros(1,5000);

for i=1:5000
    pred=predicted_case_paths(:,i);
    e=max(pred);
    ep(i)=e;
    y=find(pred==e);
    ep_t(i)=y(1);
end

%which have just 1s: assume non take offs 
x=find(ep==1);


indices=zeros(1,B);

for i=1:B
    pred=predicted_case_paths(:,i);
    %consider the time series-upto peak time:
    t_se=pred(1:ep_t(i));
%find the  last element that is equal to zero:
ind=find(t_se==0, 1, 'last' );
if isempty(ind)
    ii=0;
else
    ii=ind;
end

%check the element before is also zeros 
%n=t_se(ind-1);
%if n==0
 %   jj=ii;
%else

indices(i)=ii;
end