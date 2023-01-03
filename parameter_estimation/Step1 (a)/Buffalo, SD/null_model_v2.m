

%this version include random introduction of the disease
function [stoi,N, rates, stop1]=null_model_v2(par)
%load the stoichiometry matrix 
stoi=load('STOI_2.mat');
stoi=stoi.s;

%population size:
N={@(n) n(1)+n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)+n(12)};

%rates:
rates={@(n) par(4)*n(1); @(n) par(5)*n(2); ...
    @(n) par(1)*n(1)*((n(5)+n(6)+n(7)+n(8)+n(9))/(n(1)+ n(2) +n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)+n(12)-1)); ...
    @(n) par(1)*(1-par(2))*n(2)*((n(5)+n(6)+n(7)+n(8)+n(9))/(n(1)+ n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)+n(12)-1));...
    @(n) par(1)*(1-par(3))*n(3)*((n(5)+n(6)+n(7)+n(8)+n(9))/( n(1)+ n(2)+n(3)+n(4)+n(5)+n(6)+n(7)+n(8)+n(9)+n(10)+n(11)+n(12)-1));...
    @(n) par(6)*n(4); @(n) par(8)*n(5);  @(n) par(9)*n(6); @(n) par(7)*n(4);...
    @(n) par(10)*n(7);  @(n) par(11)*par(12)*n(8); @(n) par(11)*(1-par(12))*n(8);...
    @(n) par(13)*n(10); @(n) par(13)*n(9); @(n) par(14);...
    @(n) par(15)*n(9); @(n) par(15)*n(10)};

 stop1=@(n)  n(4)==0&&n(5)==0&&n(6)==0&&n(7)==0&&n(8)==0&&n(9)==0; 

end