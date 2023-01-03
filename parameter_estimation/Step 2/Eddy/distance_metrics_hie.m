

function[dists]=distance_metrics_hie(daily_c,inci,cases,deaths,vaccines,vaccine_cums,times,i)
    %1) cases:using euclidean distances:
    
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
        vm1=movmean(vx1,7);
        %take moving average:
        %vm1=movmean(vaccines(t,1),7);
    
        v1=abs(vm1-vaccines(t,1));
        dists(3)=sqrt(sum((v1.^2)));

        %4) vaccines: DOSE 2:euclidean distance of cumulative numbers 
       % vx2=daily_c(times(2)+1,5);
        vx2=daily_c(t,5);
        vm2=movmean(vx2,7);
        %take moving average:
        %vm2=movmean(vaccines(t,2),7);
    
        v2=abs(vm2-vaccines(t,2));
        dists(4)=sqrt(sum((v2.^2)));

        %aboslute difference on day 163 vaccines:
        %dists(5:6)=abs(inci(163,4:5)-vaccines(163,:));
        dists(5:6)=abs(inci(times(3)-1,4:5)-vaccine_cums);
        
        %importation cases to consider:
        %miner buffalo faulk towner eddy golden_valley 
        cs=[160 127 198 145 197 170];

        %Re-introduction specific values:
        ox=daily_c(cs(i):end,1);%generated 
        dists(7)=abs(sum(ox)-sum(cases(cs(i):end)));

end
