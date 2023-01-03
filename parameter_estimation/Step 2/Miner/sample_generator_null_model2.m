
%N= initial pop size 
%count==which rate numbers to count 

function[prev,daily_c,inci]=sample_generator_null_model2(times,par,N,count)
s=12; %number of states 
%initial condition: one exposed person
ini=zeros(1,s); ini(4)=1; ini(1)=N-ini(4);

 t0=[times(1) times(2)]; 
 t2=[times(2) times(4)];

Es=[];
TT=[];
CC=[];
%generate parameter sets:
nr=2;
params=repmat(par,nr,1);
params(1,2:5)=0; %vaccination related parameters at fisr are zero

ini_states=zeros(nr+1,s);
ini_states(1,:)=ini;
i=1;
while i<nr+1
 %model details:
 [stoi,~, rates, ~]=null_model_v2(params(i,:));
    [times1,paths1,counters1]=Gillespe8(ini_states(i,:),t0(i),stoi,rates,t2(i)+3,1,count);
     e1=paths1{1,1};
    cous=counters1{1,1};
    tt=times1{1,1};
    ind=find(tt<=(t2(i)), 1, 'last' ); %start day 8
     Es=[Es; e1(1:ind,:)];
     TT=[TT tt(1:ind)];
     CC=[CC; cous(1:ind,:)];
     q=round(tt(ind));
     ini_states(i+1,:)=e1(ind,:);
     i=i+1;
end
    m=times(4);
    cls=length(ini);
    prev=zeros(m,cls);
    daily_c=zeros(m,length(count));
    %daily_c(1,:)=[ini_states(5) 0 ini_states(11) 0 ini_states(17) 0]; %number of infectious people originally
    %inci=zeros(m,length(count)); %cumulative sums at each time points 
    
                        els=ones(1,q);
                        for j=1:q
                        m=find(TT>=j, 1, 'first' ); 
                        l=find(TT<j+1, 1, 'last' ); %index of T that is closest to tj
                        els(j)=l;
                        prev(j,:)=Es(l,:);
                        nc=CC(m:l,:);
                        daily_c(j,:)=sum(nc,1);
                       % cc=CC(1:l,:);
                       % inci(j,:)=sum(cc,1);%INCIDENCE FROM T=0 TO T=END
                        end
                        inci=cumsum(daily_c);

end