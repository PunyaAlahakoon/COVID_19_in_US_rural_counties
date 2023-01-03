%inistate = initial population sizes in each compartment 
%time = start time to consider 
%stoi= stoichimetry matrix 
%R = reactions
%stp1= stopping criteria 1 (absorption state)
%stp2= time criteria  time to end the algorithm (T<=tx)
%samples = number of Gillespie paths to create 
%which compartments to count for new cases

function [Times,paths,counters]= Gillespe8(ini_state,time,stoi,R,stp2,samples,count)
n = size(stoi,1); % Number of transitions
%m = size(stoi,2); % Number of states
B=samples;
paths={1,B}; %store states of all the Gillespie paths
Times={1,B};%store times of all the Gillespie paths  
counters={1,B};

for j=1:B
states= []; 
T=[];%store times
counter=[];
%initilization 
  states= [states;ini_state]; 
  T=[T time];
 counter=[counter;zeros(1,length(count))];
  %counter=[counter;ini_state(count)];%initial counter starts with counts
  %in the initial state<-this is wrong, it's a counter, start with zeros
     i=1;
     while ((T<=stp2))
        %calculate rates 
        current_R = zeros(1,n);
        for k = 1:n
        func = R{k};
        current_R(k) = func(states(i,:));
        end
    
    % Total rate
    rtot = sum(current_R);
    
    %create random nums
    r=rand(1,2);
    
    %create time of the next event 
    tau=(1/rtot)*log(1/r(1));
    Tnext=T(i)+tau;
    T=[T Tnext];
    %choose transition 
    g=rtot*r(2);
    trans=find(cumsum(current_R)>=g, 1 );
    e=min(trans);
    
     state_next= states(i,:)+ stoi(e,:); 
     states=[states;state_next];
     ct=zeros(1,length(count));
     if ismember(e,count)
         %e==count
         ct(find(count==e))=1;
     end
         counter=[counter; ct]; 
     
     i=i+1;
     
     end 
     paths{1,j}=states;
     Times{1,j}=T;
     counters{1,j}=counter;
end 
     
         

 
 

