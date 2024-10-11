%thisi step, gives the parameter step afetr one parameter step 

function[params0,w0,rho0,ag0,case_path,dose1_path,dose2_path]=abc_ind_step(g,B,params,w,cases,deaths,vaccines,vaccine_cums,e,count,times,N)
    %model definition 
    aa=1; %to make sure that you get an accepted particle from the output 
    ag=0; %set the counter
    %initilise
    params0=zeros(1,15); w0=0;
    rho0=0;
while(aa<2)
    ag=ag+1;
    if g==1
        par=prior_null2(15);
    else
        ind=randsample(1:B,1,true,w);
        par0=params(ind,:);
        ss=std(params);
        par=abs(normrnd(par0,ss));

    end

    p1=unifpdf(par(1),0.00001,2)*...
        prod(unifpdf(par(2:3),0.0001,1))*...
        unifpdf(par(4),0.0000001,0.05)*...
        unifpdf(par(5),0.0000001,0.1)*...
        lognpdf(1/par(6),0.4039,0.6)*...
        lognpdf(1/par(7),1.125,0.35)*...
        lognpdf(1/par(8),0.6619,0.25)*...
        lognpdf(1/par(9),-0.3,0.5)*...
        lognpdf(1/par(10),0.635,0.35)*....
        unifpdf(par(12),0.00001,1)*...
        lognpdf(1/(par(11)*par(12)),1.485,0.5)*...
        lognpdf(1/par(13),1.485,0.5)*....
        unifpdf(par(14),0,2)*...
        betapdf(par(15),1.5,30);

    if p1>0
        %generate a sample path;
        [~,daily_c,inci]=sample_generator_null_model2(times,par,N,count);

        %calculate distance metrics:
        [dists]=distance_metrics5(daily_c,inci,cases,deaths,vaccines,vaccine_cums,times);
        
        if all(dists<=e)
                 params0=par;
                %store distnace metrics 
                rho0=dists;
                case_path=daily_c(:,1); %save daily cases
                dose1_path=daily_c(:,4); dose2_path=daily_c(:,5); %vaccination 
                %store the weight w
                if g==1
                    w0=1;
                else
                %denominator:
                     pd=normpdf(par,params,ss); pd2=prod(pd,2);
                     den=w'.*pd2;
                    w0=p1/sum(den);   
                end
                %update a=a+1
                aa=aa+1;
                ag0=ag;
         end   

        
    end
end

end