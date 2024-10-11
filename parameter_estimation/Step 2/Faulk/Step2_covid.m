%load a vetor to specify which day to start the epidemic for parameter
%estimation 
tic

%read ind_posteriors:
miner=load('para_ind_MINER.mat');
miner=miner.para_smc;
miner=miner{1,1};

faulk=load('para_ind_Faulk.mat');
faulk=faulk.para_smc;
faulk=faulk{1,5};


buffalo=load('para_ind_Buffalo.mat');
buffalo=buffalo.para_smc;
buffalo=buffalo{1,4};

towner=load('para_ind_Towner.mat');
towner=towner.para_smc;
towner=towner{1,7};

eddy=load('para_ind_Eddy.mat');
eddy=eddy.para_smc;
eddy=eddy{1,9};


golden=load('para_ind_Golden_Valley.mat');
golden=golden.para_smc;
golden=golden{1,10};

all_ind_params=[miner; buffalo; faulk; towner; eddy; golden];


w_smc=load("all_w_smc.mat");
w_smc=w_smc.w_smc;

cc=[1 4 5 7 9 10]; % the county to consider 
%miner buffalo faulk towner eddy goden_valley 
st_days=[154 150 152 176 129 135];



%load county population sizes:
pops=readtable('pop_sizes_2019.csv');
pop_N=table2array(pops);
pop_N=pop_N(cc);

%load case data:
 data=readtable('case_numbers.csv');
 y=table2array(data(:,2:13));
 y=y(:,cc);

%load death data:
dt=readtable("deaths.csv");
ds=table2array(dt(:,2:13));
ds=ds(:,cc);


 %vaccine date:
 vim=zeros(14,6); %shift the vaccinations to 14 days 
vt1=readtable("dose1_time_series.csv");
vv1=table2array(vt1(:,2:13));
vv1=vv1(:,cc);
v1=[vim;vv1(1:end-14,:)];
vt2=readtable("dose2_time_series.csv");
vv2=table2array(vt2(:,2:13));
vv2=vv2(:,cc);
v2=[vim;vv2(1:end-14,:)];


dim=size(y,2); %number of counties to consider 

%Number of particles/ parameters sets to sample using ABC-SMC
B=1;


%read the hyper parameters fro m7000 to 27000. Take every 2nd value 
%load hyper parameters
hbs=readtable('hb5.csv');
hbs=table2array(hbs);
hbs=hbs(10001:50000,:); %burn-in 
hbs=hbs(1:40:end,2:end); %take every 20th elemnet 

hb_sigs=readtable('hb_sig5.csv');
hb_sigs=table2array(hb_sigs);
hb_sigs=hb_sigs(10001:50000,:); %burn-in 
hb_sigs=hb_sigs(1:40:end,2:end); %take every 2nd elemnet 


ross=readtable('ros5.csv');
ross=table2array(ross);
ross=ross(10001:50000,:); %burn-in 
ross=ross(1:40:end,2:end); %take every 2nd element0

%load tolerances:
e=load('E_all.mat');
e=e.B;
e=sqrt(sum(e.^2,2));
%e=e(:,1);
%e=reshape(e',1,6);

%et=[60 10 80 100 296 60 15];
%et=[160 100 120 180 500 80 50];
%et=repmat(250,1,7);

%e=repmat(et,6,1); %for testing 
%e=repmat(1000,1,6);

%store parameters:
np=15; %number of parameters to estimate 
para_hie=zeros(B,90);
sx={1,dim};
accepted_case_paths={1,B};
accepted_dose1_paths={1,B};
accepted_dose2_paths={1,B};
AG=zeros(1,B);
dists=zeros(1,7);


parfor i=1:B
[para_hie(i,:),accepted_case_paths{i},accepted_dose1_paths{i},accepted_dose2_paths{i},AG(i),dists(i,:)]=...
    abc_hie_covid3(pop_N,y,ds,v1,v2,all_ind_params,w_smc,e,hbs(i,:),hb_sigs(i,:),ross(i,:));

end

toc
