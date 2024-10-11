
function[params,case_path,dose1_path,dose2_path,ag0,rho0]=abc_hie_covid(pop_N,y,ds,v1,v2,ind_pars,w_smc,e,hb,hb_sig,cor)
 aa=1; %to make sure that you get an accepted particle from the output 
    ag=0; %set the counter
      n=6; %number of counties 
    %initilise
    params=zeros(1,15*n); 
    rho0=0;
     %get the start days:
            %miner buffalo faulk towner eddy goden_valley 
            st_days=[154 150 152 176 129 135];

    count=[11 16 17 1 2];%these are the same for all the counties 
  
%  dists=repmat(1000,n,7);


while (aa<2)

    ag=ag+1;
    
        par=priors_hie2(hb,hb_sig,cor,ind_pars,w_smc);
   

    p1=prod(unifpdf(par(:,1),0.00001,2))*...
        prod(prod(unifpdf(par(:,2:3),0.0001,1)))*...
        prod(unifpdf(par(:,4),0.0000001,0.05))*...
        prod(unifpdf(par(:,5),0.0000001,0.1))*...
        lognpdf(1./par(1,6),0.4039,0.6)*...
        lognpdf(1./par(1,7),1.125,0.35)*...
        lognpdf(1./par(1,8),0.6619,0.25)*...
        lognpdf(1./par(1,9),-0.3,0.5)*...
        lognpdf(1./par(1,10),0.635,0.35)*....
        prod(unifpdf(par(:,12),0.00001,1))*...
        prod(lognpdf(1./(par(:,11).*par(:,12)),1.485,0.5))*...
        prod(lognpdf(1./par(:,13),1.485,0.5))*....
        unifpdf(par(1,14),0,2)*... %miner
        unifpdf(par(2,14),0,0.8)*...%buffalo
        unifpdf(par(3,14),0,2)*... %faulk
        unifpdf(par(4,14),0,3)*...%towner
        unifpdf(par(5,14),0,0.6)*...%eddy
        unifpdf(par(6,14),0,2)*...%golden valley 
        betapdf(par(1,15),1.5,30);

    if p1>0
        daily_cases=zeros(446,6);
        dose1_paths=zeros(446,6);
        dose2_paths=zeros(446,6);
        
        dists=repmat(1000,n,7);
       %dists=zeros(n,7);
        %generate a sample paths;
          for i=1:n
           
             N=pop_N(i); %initial population size 
             cases=y(st_days(i):446,i); deaths=ds(st_days(i):446,i); %446 is the length of the days 
                %vaccine first dose availbility: depends on states SD:12/15/2020 ND: 12/14/2020
                if ismember(i,1:3) %SD; k=1:6
                vi=264-st_days(i);  %264 is the day of vaccine availbility out of original time frame 
                else
                vi=263-st_days(i);
                end
                  %find the day to start the vaccine time-series: 
                vcc1=(v1(st_days(i):446,i)); vcc2= (v2(st_days(i):446,i));
                ind=[find(isnan(vcc1), 1, 'last' ) find(isnan(vcc2), 1, 'last' )]; 
                cv=[find(vcc1(ind(1)+1:end)~=0,1,'first')+ind(1) find(vcc2(ind(2)+1:end)~=0,1,'first')+ind(2)];
            %cv(1) and cv(2) are the same for both doses
    
                vaccines=[[zeros(cv(1),1); movmean(vcc1(cv(1)+1:end),7)] [zeros(cv(2),1); movmean(vcc2(cv(2)+1:end),7)]];
                vacc_cum=[vcc1(cv(1)) vcc2(cv(2))];
                times=[0 vi cv(1)+1 length(cases)];

            [~,daily_c,inci]=sample_generator_null_model2(times,par(i,:),N,count);
            daily_cases(1:size(daily_c,1),i)= daily_c(:,1); %save daily cases
             dose1_paths(1:size(daily_c,1),i)=daily_c(:,4);
               dose2_paths(1:size(daily_c,1),i)=daily_c(:,5);
            %calculate distance metrics:
            dists(i,:)=distance_metrics_hie(daily_c,inci,cases,deaths,vaccines,vacc_cum,times,i);
               if any(dists(i,:)>e(i,:))
                   i=n;
                   break
               end
          end

      
            %dists=dists(1,:);
            %ee=e(1,:);
                %ists=reshape(dists',1,42);
               % ee=reshape(e',1,42);
        if all(dists<=e,'all')

                 params=reshape(par',1,15*n);
                %store distnace metrics 
                rho0=reshape(dists',1,42);
                case_path=daily_cases;
                dose1_path=dose1_paths; dose2_path=dose2_paths; %vaccination 
                %store the weight w
       
                %update a=a+1
                aa=aa+1;
                ag0=ag;
         end   

        
     
    end
end




end
