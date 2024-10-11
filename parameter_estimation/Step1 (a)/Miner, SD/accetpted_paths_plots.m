figure(1)


for i=1:1000
    plot(accepted_case_paths(:,i),Color='#808080')
    hold on 
end


plot(cases,LineWidth=.7,Color='black')
ylim([0 15])



