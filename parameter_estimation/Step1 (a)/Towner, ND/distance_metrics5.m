
%%%THIS VERSION:: TO USE 1) TOLERANCE FOR THE EPI-CURVE 2) TOLERANCE FOR THE RE-INTRODUCTIONS 

%depends on the generation 

%calculate distance criteria 
%counts=[11=daily_notified cases 16:17=deaths 4=dose 1 5=dose2]
%vaccines are moving averages 

function[dists]=distance_metrics5(daily_c,inci,cases,deaths,vaccines,vaccine_cums,times)
        %1) cases:using euclidean distances:
        %For Miner epi-curve is 1-159 days (AFTER shifting the time-series
        %to ignore 
        ox=daily_c(:,1);%generated 
        cs=abs(ox-cases); %observed
        dists(1)=sqrt(sum((cs.^2)));
     
        %2) deaths: absolute difference
        dx=sum(inci(end,2:3));
        dists(2)=abs(dx-deaths(end));

        %3) vaccines: DOSE 1:euclidean distance of cumulative numbers 
        %vx1=daily_c(times(2)+1:end,4);
        t=times(3):length(cases);
        vx1=daily_c(t,4);
           %take cum sum 
        vm1=sum(vx1);
        %take moving average:
        %vm1=movmean(vaccines(t,1),7);
    
        v1=abs(vm1-sum(vaccines(t,1)));
        dists(3)=v1;

        %4) vaccines: DOSE 2:euclidean distance of cumulative numbers 
       % vx2=daily_c(times(2)+1,5);
        vx2=daily_c(t,5);
          vm2=sum(vx2);
        %take moving average:
        %vm2=movmean(vaccines(t,2),7);
    
         v2=abs(vm2-sum(vaccines(t,2)));
        dists(4)=v2;
        %aboslute difference on day 163 vaccines:
        %dists(5:6)=abs(inci(163,4:5)-vaccines(163,:));
        %dists(5:6)=abs(inci(times(3)-1,4:5)-vaccine_cums);

        %Re-introduction specific values:
        or=daily_c(145:end,1);%generated 
        dists(5)=abs(sum(or)-sum(cases(145:end)));
        
         %initial re-introduction specific values:
        oi=daily_c(1:22,1);%generated 
        dists(6)=abs(sum(oi)-sum(cases(1:22)));
        
          %add two more summary stats for the begining of the vaccine intake
        %for the two doses 
        dists(7)=abs(sum(daily_c(1:times(3),4))-(vaccines(times(3),1)));
        dists(8)=abs(sum(daily_c(1:times(3),5))-(vaccines(times(3),2)));


end