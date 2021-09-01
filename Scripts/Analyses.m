clear;
close all
clc;
addpath(genpath('../Functions'));
addpath(genpath('./functions')); 

trials = {'ABER', 'ABIR', 'Ext', 'Flex', 'Backp', 'Eat', 'Hair', 'Jerk', 'Scapt'};
resultsFolder = '../Results/CAST';
reconstType = 'Q2';
nRep = 5;
nFrames = 1000;
showAllCurves = false;
showMean = false;
showErrorAllCurves = false;
showErrorMean = true;
saveFigure = true;
saveFoler = 'fig';
sigDifferentColor = [0.6, 0.2, 0.2];
dofToPlot = 2; % 'all'

% FOR MODEL PreSurgery and SkinAndBrace
subjectsToUse = [2, 4, 7, 8];
modelsToUse = {{2.0, 'SkinAndBrace', 'r'}, {1.1, 'SkinAndBrace', 'b'}};

% % FOR MODEL Brace
% % subjectsToUse = [4, 7];
% modelsToUse = [2.0, 3.0];
% modelColors = 'rbgmcy';


subjects = prepareSubjects(subjectsToUse);
models = prepareModels(modelsToUse);

for iT = 1:length(trials)
    trial = trials{iT};
    
    nDofToShow = length(models(1).dofToShow);
    for iM = 2:length(models)
        if length(models(iM).dofToShow) ~= nDofToShow
            error('All dofToShow must be of same length')
        end
    end
    
    % Collect the data
    allQ = loadData(resultsFolder, trial, reconstType, nDofToShow, nFrames, nRep, subjects, models);

    [allQmean, allQstd] = computeMean(allQ);

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
            ax(iD) = axes();
            hold on
        end
        for iS = 1:length(subjects)
            for iM = 1:length(models)
                for iR = 1:nRep
                    for iD = 1:nDofToShow
                        plot(ax(iD), t, allQ(dofToPlot(iD), :, iR, iS, iM) * models(iM).dofToShowFactor{iD}, models(iM).color)
                    end
                end
            end
        end
    end

    if showMean
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes();
            hold on
        end
        for iD = 1:nDofToShow
            axes(ax(iD)); %#ok<LAXES>
            for iS = 1:length(subjects)
                for iM = 1:length(models)
                    stdshade(squeeze(allQ(dofToPlot(iD), :, :, iS, iM))' * models(1).dofToShowFactor{iD}, 0.1, models(iM).color, t);
                end
            end
        end
    end


    if showErrorAllCurves
        for iD = 1:nDofToShow
            figure
            ax(iD) = axes();
            hold on
        end
        if length(models) ~= 2
            error('Models should be exactly 2 for showing error')
        end

        for iD = 1:nDofToShow
            axes(ax(iD)); %#ok<LAXES>
            for iS = 1:length(subjects)
                data1 = squeeze(allQ(dofToPlot(iD), :, :, iS, 1))';
                data2 = squeeze(allQ(dofToPlot(iD), :, :, iS, 2))';
                stdshade(abs(data1 - data2) * models(1).dofToShowFactor{iD}, 0.1, models(iM).color, t);
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
            data1 = reshape(squeeze(allQ(dofToPlot(iD), :, :, :, 1)), nFrames, [])';
            data2 = reshape(squeeze(allQ(dofToPlot(iD), :, :, :, 2)), nFrames, [])';

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
                print(sprintf('%s/%s.png', saveFoler, trial), '-dpng', '-r300')
            end
        end
    end
end



