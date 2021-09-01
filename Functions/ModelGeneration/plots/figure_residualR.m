function figure_residualR(conf, r,s, resid1, resid2, frames)


figure('name', sprintf('%s  et %s : Residu matrice de rotation', conf.S(r).name, conf.S(s).name));
subplot(221), hist(resid1*1000,100,'EdgeColor','w'), 
title(['Occurrence of residual for ' conf.S(r).name]); ylabel('Occurrence')
xlabel(sprintf('Residual (mm): %2.1f (%2.1f) mm\n',mean(resid1)*1000, std(resid1)*1000))
LE={}; for le=1:size(resid1,2), LE=[LE, sprintf('M%d',le)]; end; legend(LE);

subplot(223), hist(resid1(frames,:)*1000,100,'EdgeColor','w'), 
title(['Occurrence of residual (selected frames)for ' conf.S(r).name]); ylabel('Occurrence')
xlabel(sprintf('Residual (mm): %2.1f (%2.1f) mm\n',mean(resid1(frames,:))*1000, std(resid1(frames,:))*1000))
LE={}; for le=1:size(resid1,2), LE=[LE, sprintf('M%d',le)]; end; legend(LE);

if ~isempty(resid2)
    subplot(222), hist(resid2 *1000,100,'EdgeColor','w'), 
    title(['Occurrence of residual for ' conf.S(s).name]); ylabel('Occurrence')
    xlabel(sprintf('Residual (mm): %2.1f (%2.1f) mm\n',mean(resid2)*1000, std(resid2)*1000))
    LE={}; for le=1:size(resid2,2), LE=[LE, sprintf('M%d',le)]; end; legend(LE);

    subplot(224), hist(resid2(frames,:)*1000,100,'EdgeColor','w'), 
    title(['Occurrence of residual for ' conf.S(s).name]); ylabel('Occurrence')
    xlabel(sprintf('Residual (mm): %2.1f (%2.1f) mm\n',mean(resid2(frames,:))*1000, std(resid2(frames,:))*1000))
    LE={}; for le=1:size(resid2,2), LE=[LE, sprintf('M%d',le)]; end; legend(LE);
end