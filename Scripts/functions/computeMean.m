function [allMean, allStd] = computeMean(allQ)
    % Reminder allQ is [nDofToShow, nFrames, nRep, length(subjects), length(models)];
    allMean = mean(allQ, 3, 'omitnan');
    allStd = std(allQ, [], 3, 'omitnan');
end