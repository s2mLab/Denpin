function  figure_residualCoR(conf, r,s,residual0, residual)


figure('name', sprintf('%s - %s : Residu pour le centre articulaire', conf.S(r).name, conf.S(s).name));
subplot(121), hist(residual0*1000,100,'FaceColor','r','EdgeColor','w'), 
title(['Occurrence of SCoRE residual for ' conf.S(s).name ' (first iteration)'])
ylabel('Occurrence')
xlabel(sprintf('SCoRE residual (mm): %2.1f (%2.1f) mm',mean(residual0)*1000, std(residual0)*1000))

subplot(122), hist(residual *1000,100,'FaceColor','b','EdgeColor','w'), 
title(['Occurrence of SCoRE residual for ' conf.S(s).name])
ylabel('Occurrence')
xlabel(sprintf('SCoRE residual (mm): %2.1f (%2.1f) mm',mean(residual)*1000, std(residual)*1000))
