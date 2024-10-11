

vcc1=[zeros(163,1); movmean(v1(164:end,k),7)];
vcc2=[zeros(163,1); movmean(v2(164:end,k),7)];

tiledlayout(1,3)
nexttile
plot(accepted_case_paths{1,1})
hold on 
plot(cases)
hold off
nexttile
plot(movmean(accepted_dose1_paths{1,1},7))
hold on 
plot(vcc1)
hold off 
nexttile
plot(movmean(accepted_dose2_paths{1,1},7))
hold on 
plot(vcc2)
hold off 