pars=para_smc{1,4};
s=sx{1,4};

tiledlayout(2,3);

nexttile
scatter(pars(:,1),s(:,1))

nexttile
scatter(pars(:,4),s(:,3))

nexttile
scatter(pars(:,4),s(:,5))

nexttile
scatter(pars(:,4),s(:,4))

nexttile
scatter(pars(:,4),s(:,6))