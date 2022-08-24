clear;
close all
clc;
addpath(genpath('../Functions'));
addpath(genpath('./functions')); 

isScapula = true;
useJerk = false;
trials = {'ABER', 'ABIR', 'Ext', 'Flex', 'Backp', 'Eat', 'Hair', 'Scapt'};
if useJerk
    trials = [trials, 'Jerk'];
end
resultsFolder = '../Results/CAST';
reconstType = 'Q2';
nRep = 5;
nFrames = 1000;
resetToZero = false;
showAllCurves = true;
showMean = true;
showErrorAllCurves = true;
showErrorMean = true;
saveFigure = true;
saveFoler = 'results/tp/';
sigDifferentColor = [0.6, 0.2, 0.2];
dofToPlot = 3;

% FOR MODEL PreSurgery and SkinAndBrace
if isScapula
    if useJerk
        subjectsToUse = [2:5 7 8];
    else
        subjectsToUse = 1:8;
    end
else
    subjectsToUse = [2, 4, 7, 8];
end
modelsToUse = {{102.0, 'SkinAndBrace', 'r'}, {101.1, 'SkinAndBrace', 'b'}};

% % FOR MODEL Brace
% % subjectsToUse = [4, 7];
% modelsToUse = [2.0, 3.0];
% modelColors = 'rbgmcy';


subjects = prepareSubjects(subjectsToUse);
models = prepareModels(modelsToUse, isScapula);


allQ = cell(1, length(trials));
nDofRms = length(models(1).dofToShowNames);
pRms = nan(nDofRms, length(trials));
pRmse = nan(nDofRms, length(trials));
meanRmseQ = nan(nDofRms, length(trials));
rmseQ = nan(nDofRms, length(trials));
stdQ = nan(nDofRms, length(trials));
romMean = nan(nDofRms, length(trials), length(models));
romStd = nan(nDofRms, length(trials), length(models));
showMean = false;
showAllCurves = false;
showErrorAllCurves = false;
showErrorMean = false;
saveFigure = false;
saveResults = true;
showRoM = true;
for iT = 1:length(trials)
    trial = trials{iT};
    
    nDofToShow = length(models(1).dofToShow);
    for iM = 2:length(models)
        if length(models(iM).dofToShow) ~= nDofToShow
            error('All dofToShow must be of same length')
        end
    end
    
    % Collect the data
    allQ{iT} = loadData(resultsFolder, trial, reconstType, nDofToShow, nFrames, nRep, subjects, models, resetToZero);

    [allQmean, allQstd] = computeMean(allQ{iT});

    t = linspace(0, 100, nFrames);

    if strcmp(dofToPlot, 'all')
        dofToPlot = models(1).dofToShow;
    end
    nDofToShow = length(dofToPlot);

    % Give the data a plot
    % Reminder allQ is [nDofToShow, nFrames, nRep, length(subjects), length(models)];
    if showAllCurves
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes(); %#ok<SAGROW>
            title(sprintf('%s - %s', trial, models(1).dofToShowNames{dofToPlot(iD)}))
            xlabel('Time (%)');
            ylabel(sprintf('Translation (%s)', models(1).dofToShowYLabel{dofToPlot(iD)}))
            hold on
        end
        for iS = 1:length(subjects)
            for iM = 1:length(models)
                for iR = 1:nRep
                    for iD = 1:nDofToShow
                        plot(ax(iD), t, allQ{iT}(dofToPlot(iD), :, iR, iS, iM) * models(iM).dofToShowFactor{dofToPlot(iD)}, models(iM).color)
                    end
                end
            end
        end
    end

    if showMean
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes();
            title(sprintf('%s - %s', trial, models(1).dofToShowNames{dofToPlot(iD)}))
            xlabel('Time (%)');
            ylabel(sprintf('Translation (%s)', models(1).dofToShowYLabel{dofToPlot(iD)}))
            hold on
        end
        for iD = 1:nDofToShow
            axes(ax(iD)); %#ok<LAXES>
            for iS = 1:length(subjects)
                for iM = 1:length(models)
                    stdshade(squeeze(allQ{iT}(dofToPlot(iD), :, :, iS, iM))' * models(1).dofToShowFactor{dofToPlot(iD)}, 0.1, models(iM).color, t);
                end
            end
        end
        
        if saveFigure
            if ~exist(saveFoler, 'dir')
                mkdir(saveFoler)
            end
            print(sprintf('%s/MeanSubject_%s.png', saveFoler, trial), '-dpng', '-r300')
        end
    end


    if showErrorAllCurves
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes();
            title(sprintf('%s - %s', trial, models(1).dofToShowNames{dofToPlot(iD)}))
            xlabel('Time (%)');
            ylabel(sprintf('Error (%s)', models(1).dofToShowYLabel{dofToPlot(iD)}))
            hold on
        end
        if length(models) ~= 2
            error('Models should be exactly 2 for showing error')
        end

        for iD = 1:nDofToShow
            axes(ax(iD)); %#ok<LAXES>
            for iS = 1:length(subjects)
                data1 = squeeze(allQ{iT}(dofToPlot(iD), :, :, iS, 1))';
                data2 = squeeze(allQ{iT}(dofToPlot(iD), :, :, iS, 2))';
                stdshade(abs(data1 - data2) * models(1).dofToShowFactor{dofToPlot(iD)}, 0.1, models(iM).color, t);
            end
        end
    end


    if showErrorMean
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes();
            title(sprintf('%s - %s', trial, models(1).dofToShowNames{dofToPlot(iD)}))
            xlabel('Time (%)');
            ylabel(sprintf('Error (%s)', models(1).dofToShowYLabel{dofToPlot(iD)}))
            hold on
        end
        if length(models) ~= 2
            error('Models should be exactly 2 for showing error')
        end

        for iD = 1:nDofToShow
            axes(ax(iD)); %#ok<LAXES>
            data1 = reshape(squeeze(allQ{iT}(dofToPlot(iD), :, :, :, 1)), nFrames, [])';
            data2 = reshape(squeeze(allQ{iT}(dofToPlot(iD), :, :, :, 2)), nFrames, [])';

            notNanData = ~isnan(sum(data1, 2)) | ~isnan(sum(data2, 2));
            data1 = data1(notNanData, :);
            data2 = data2(notNanData, :);

            spm = spm1d.stats.nonparam.ttest_paired(data1, data2);
            spmi = spm.inference(0.05, 'two_tailed', true, 'interp',true, 'iterations', 1000);

            stdshade(abs(data2 - data1) * models(1).dofToShowFactor{dofToPlot(iD)}, 0.1, models(iM).color, t);

            axes(ax(iD)); %#ok<LAXES>
            lim = ylim();
            for iStats = 1:length(spmi.clusters)
                area(spmi.clusters{iStats}.endpoints / nFrames * 100, [lim(2), lim(2)],'facecolor', sigDifferentColor, 'facealpha', 0.1, 'edgecolor', 'None')
            end
            
            if saveFigure
                if ~exist(saveFoler, 'dir')
                    mkdir(saveFoler)
                end
                print(sprintf('%s/MeanError_%s.png', saveFoler, trial), '-dpng', '-r300')
            end
        end
    end
    
    % Compute range of motion
    if showRoM
        for iM = 1:length(models)
            for iRom = 1:size(allQ{iT}, 1)
                minVal = squeeze(min(allQ{iT}(iRom, :, :, :, iM), [], 2));
                maxVal = squeeze(max(allQ{iT}(iRom, :, :, :, iM), [], 2));
                allRom = reshape(maxVal - minVal, [], 1);
                romMean(iRom, iT, iM) = mean(allRom, 'omitnan');
                romStd(iRom, iT, iM) = std(allRom, 'omitnan');
            end
        end
    end
    
    % compute RMSE between the two models and statistic on them
    if size(allQ{iT}, 5) ~= 2
        error('RMSE can only be computed between two models');
    end
    rmsQForP = reshape(rms(allQ{iT}, 2), nDofRms, [], 2);
    rmseQForP = reshape(rms(allQ{iT}(:, :, :, :, 1) - allQ{iT}(:, :, :, :, 2), 2), nDofRms, []);
    for iQ = 1:nDofRms
        [~, p] = ttest(rmsQForP(iQ, :, 1), rmsQForP(iQ, :, 2));
        pRms(iQ, iT) = p;
        [~, p] = ttest(rmseQForP(iQ, :));
        pRmse(iQ, iT) = p;
    end
    meanRmseQ(:, iT) = mean(rmseQForP, 2, 'omitnan');
    rmseQ(:, iT) = sqrt(mean( reshape((allQ{iT}(:, :, :, :, 1) - allQ{iT}(:, :, :, :, 2)).^2, nDofRms, []), 2, 'omitnan'));
    stdQ(:, iT) = std(reshape(allQ{iT}(:, :, :, :, 1) - allQ{iT}(:, :, :, :, 2), nDofRms, []), [], 2, 'omitnan');
end

if showRoM
    [~, idxTMaxRom] = max(romMean, [], 2);
    idxTMaxRom = squeeze(idxTMaxRom);
    for iChoose = 1:size(idxTMaxRom, 2) 
        for iDof = 1:size(idxTMaxRom, 1)
            figure
            ax(iDof) = axes();
            trial = trials{idxTMaxRom(iDof, iChoose)};
            basedOn = models(iChoose).source;
            title(sprintf('%s', trial));
            xlabel('Time (%)');
            ylabel(sprintf('%s (%s)', models(iM).dofToShowNames{iDof}, models(iM).dofToShowYLabel{iDof}))
            hold on

            for iM = 1:length(models)
                data = reshape(allQ{idxTMaxRom(iDof, iChoose)}(iDof, :, :, :, iM), nFrames, []);
                stdshade((data * models(iM).dofToShowFactor{iDof})', 0.1, models(iM).color, t);
            end
            
            if saveFigure
                if ~exist(saveFoler, 'dir')
                    mkdir(saveFoler)
                end
                print(sprintf('%s/MeanDofMaxRoM(%s)_%s__basedOn_%s.png', saveFoler, models(iM).dofToShowNames{iDof}, trial, basedOn), '-dpng', '-r300')
            end
        end
    end
end

if saveResults
    if ~exist(saveFoler, 'dir')
        mkdir(saveFoler)
    end
    
    xlswrite([saveFoler '/meanRmse.xls'], meanRmseQ .* repmat([models(1).dofToShowFactor{:}]', 1, size(rmseQ, 2)));
    xlswrite([saveFoler '/rmseQ.xls'], rmseQ .* repmat([models(1).dofToShowFactor{:}]', 1, size(rmseQ, 2)));
    xlswrite([saveFoler '/stdQ.xls'], stdQ .* repmat([models(1).dofToShowFactor{:}]', 1, size(rmseQ, 2)));
    xlswrite([saveFoler '/p_rms.xls'], pRms)
    xlswrite([saveFoler '/p_rmse.xls'], pRmse)
    
    if showRoM
        for iM = 1:length(models)
            xlswrite(sprintf([saveFoler '/RoM_mean_%s.xls'], models(iM).source), romMean(:, :, iM) .* repmat([models(1).dofToShowFactor{:}]', 1, size(romMean, 2)));
            xlswrite(sprintf([saveFoler '/RoM_std_%s.xls'], models(iM).source), romStd(:, :, iM) .* repmat([models(1).dofToShowFactor{:}]', 1, size(romStd, 2)));
        end
    end
end


