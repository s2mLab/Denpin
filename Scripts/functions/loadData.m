function allQ = loadData(resultsFolder, trial, reconstType, nDofToShow, nFrames, nRep, subjects, models, resetToZero)
    warningWritten = false;
    allQ = nan(nDofToShow, nFrames, nRep, length(subjects), length(models));
    for iS = 1:length(subjects)
        for iM = 1:length(models)
            currentDir = [resultsFolder '/' subjects(iS).name '/' models(iM).folder '/'];
            file = dir(sprintf('%s/%s*MOD%1.2f*.%s', currentDir, trial, models(iM).number, reconstType));
            if isempty(file)
                error('%s not found for %s in %s', trial, subjects(iS).name, models(iM).folder);
            elseif length(file) > 1 && ~strcmp(trial, 'Throw')
                error('Multiple %s found for %s in %s', trial, subjects(iS).name, models(iM).folder);
            end

            if strcmp(trial, 'Throw')
                Q = [];
                for iF = 1:length(file)
                    tp = load([currentDir file(iF).name], '-mat');
                    tp = tp.(reconstType);
                    Q = [Q tp]; %#ok<AGROW>
                end 
            else
                Q = load([currentDir file.name], '-mat');
                Q = Q.(reconstType);
            end

            % Keep data into [0 2*pi]
            if length(models(iM).rotIdx) ~= length(models(iM).rotSeqIn)
                error('The rotIdx, rotSeqIn and rotSeqOut must have the same number of segment');
            elseif length(models(iM).rotSeqIn) ~= length(models(iM).rotSeqOut)
                error('The rotIdx, rotSeqIn and rotSeqOut must have the same number of segment');
            end
            for iR = 1:length(models(iM).rotIdx)
                rotIdx = models(iM).rotIdx{iR};
                rotSeqIn = models(iM).rotSeqIn{iR};
                rotSeqOut = models(iM).rotSeqOut{iR};
                tp = fromAngleToMatrix(Q(rotIdx, :), rotSeqIn);
                Q(rotIdx, :) = unwrap(fromMatrixToAngle(tp, rotSeqOut)')'; %#ok<AGROW>
            end

            if strcmpi(subjects(iS).armTested, 'right')
                for iRL = 1:length(models(iM).rightToLeft)
                    idxRL = models(iM).rightToLeft{iRL};
                    Q(abs(idxRL), :) = sign(idxRL) * Q(abs(idxRL), :);  %#ok<AGROW>
                end
            end

            % Cut the data (find peaks and keep the nRep trial in the middle (nRep + 1 peaks)
            if strcmp(trial, 'ABER') || strcmp(trial, 'ABIR')
                if ~warningWritten
                    fprintf('For ABER and ABIR, the trial starts at the lowest point of the arm\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'y');
                [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 350);
                idxPeaks = idxPeaks(idxPeaks > 300 & idxPeaks < size(Q, 2) - 300);

            elseif strcmp(trial, 'Backp')
                if ~warningWritten
                    fprintf('For Backp, the trial starts at the front\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'x');
                [~, idxPeaks] = findpeaks(-Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 250);
                idxPeaks = idxPeaks(idxPeaks > 400 & idxPeaks < size(Q, 2) - 300);

            elseif strcmp(trial, 'Eat')
                if ~warningWritten
                    fprintf('For Eat, the trial starts at the lowest point of the arm\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'x');
                if strcmp(subjects(iS).name, 'Subject1')
                    [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 175);
                elseif strcmp(subjects(iS).name, 'Subject8')
                    [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 300);
                else
                    [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 200);
                end
                idxPeaks = idxPeaks(idxPeaks > 150 & idxPeaks < size(Q, 2) - 150);
                if strcmp(subjects(iS).name, 'Subject4') && models(iM).number == 1.1 && strcmp(models(iM).folder, 'SkinAndBrace')
                    idxPeaks = idxPeaks(2:end);
                end

            elseif strcmp(trial, 'Ext')
                if ~warningWritten
                    fprintf('For Ext, the trial starts at the most extended point on GH(x)\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'x');
                [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 175);
                idxPeaks = idxPeaks(idxPeaks > 100 & idxPeaks < size(Q, 2) - 100);

            elseif strcmp(trial, 'Flex')
                if ~warningWritten
                    fprintf('For Flex, the trial starts at the lowest point of the arm\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'x');
                [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 350);
                idxPeaks = idxPeaks(idxPeaks > 300 & idxPeaks < size(Q, 2) - 300);
                idxPeaks = idxPeaks(idxPeaks > 300 & idxPeaks < size(Q, 2) - 300);

            elseif strcmp(trial, 'Hair')
                if ~warningWritten
                    fprintf('For Hair, the trial starts at the lowest point of the arm\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'x');
                if strcmp(subjects(iS).name, 'Subject3')
                    [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 300);
                else
                    [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 250);
                end
                idxPeaks = idxPeaks(idxPeaks > 300 & idxPeaks < size(Q, 2) - 300);

            elseif strcmp(trial, 'Jerk')
                if ~warningWritten
                    fprintf('For Jerking, the trial starts internally rotated\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'z');
                
                [~, idxPeaksMax] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 75);
                idxPeaksMax = idxPeaksMax(idxPeaksMax > 200 & idxPeaksMax < size(Q, 2) - 50);
                idxPeaksMax = idxPeaksMax(Q(models(iM).GHrot(dof), idxPeaksMax) > 0.2);
                
                % Find peak at middle point between two max
                n = 20;
                idxPeaks = nan(1, size(idxPeaksMax, 2) - 1);
                for idx = 1:size(idxPeaksMax, 2) - 1
                    pts = idxPeaksMax(idx) + n:idxPeaksMax(idx + 1) - n;
                    [~, idxPeaks_tp] = findpeaks(-Q(models(iM).GHrot(dof), pts), 'MinPeakDistance', 30);
                    idxPeaks_tp = idxPeaks_tp + idxPeaksMax(idx) - 1 + n;
                    [~, toKeep] = min(abs(idxPeaks_tp - (idxPeaksMax(idx) + idxPeaksMax(idx + 1)) / 2));
                    idxPeaks(idx) = idxPeaks_tp(toKeep);
                end
                
            elseif strcmp(trial, 'Scapt')
                if ~warningWritten
                    fprintf('For Scapt, the trial starts at the lowest point of the arm\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'y');
                [~, idxPeaksMax] = findpeaks(-Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 100);
                idxPeaksMax = idxPeaksMax(idxPeaksMax > 200 & idxPeaksMax < size(Q, 2) - 200);
                if strcmp(subjects(iS).name, 'Subject3')
                    idxPeaksMax = idxPeaksMax(Q(models(iM).GHrot(dof), idxPeaksMax) < -0.6);
                else
                    idxPeaksMax = idxPeaksMax(Q(models(iM).GHrot(dof), idxPeaksMax) < -1);
                end
                
                % Find peak at middle point between two max
                n = 100;
                idxPeaks = nan(1, size(idxPeaksMax, 2) - 1);
                for idx = 1:size(idxPeaksMax, 2) - 1
                    pts = idxPeaksMax(idx) + n:idxPeaksMax(idx + 1) - n;
                    [~, idxPeaks_tp] = findpeaks(Q(models(iM).GHrot(dof), pts), 'MinPeakDistance', 30);
                    idxPeaks_tp = idxPeaks_tp + idxPeaksMax(idx) - 1 + n;
                    [~, toKeep] = min(abs(idxPeaks_tp - (idxPeaksMax(idx) + idxPeaksMax(idx + 1)) / 2));
                    idxPeaks(idx) = idxPeaks_tp(toKeep);
                end

            elseif strcmp(trial, 'Throw')
                if ~warningWritten
                    fprintf('For Eat, the trial starts at the lowest point on GH(z)\n');
                    warningWritten = true;
                end
                dof = strfind(models(iM).rotSeqOut{2}, 'z');
                [~, idxPeaks] = findpeaks(Q(models(iM).GHrot(dof), :), 'MinPeakDistance', 300);
                idxPeaks = idxPeaks(idxPeaks > 300 & idxPeaks < size(Q, 2) - 300);

            else
                error('No peak finding policy for %s', trial)
            end

            if strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'Flex') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject8 did only four Fkex in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'ABIR') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject8 did only three ABIR in SkinAndBrace\n');
                if nRep >= 4
                    idxPeaks = idxPeaks(1:4);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'Backp') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject8 did only four Backp in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'Hair') && (strcmp(models(iM).folder, 'PreSurgery') || strcmp(models(iM).folder, 'SkinAndBrace'))
                fprintf('Subject8 did only three Hair in PreSurgery and in SkinAndBrace\n');
                if nRep >= 4
                    idxPeaks = idxPeaks(1:4);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'Scapt') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject8 did only four Scaption in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject2') && ...
                    strcmp(trial, 'Scapt') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject2 had reconstruction problem for Scaption in SkinAndBrace\n');
                if nRep >= 3
                    idxPeaks = idxPeaks(2:4);
                else
                    idxPeaks = idxPeaks(2:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject8') && ...
                    strcmp(trial, 'ABER') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject8 did only four ABER in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject6') && ...
                    strcmp(trial, 'ABER') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject3 did only four ABER in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            elseif strcmp(subjects(iS).name, 'Subject6') && ...
                    strcmp(trial, 'Flex') && strcmp(models(iM).folder, 'SkinAndBrace')
                fprintf('Subject3 did only four Flex in SkinAndBrace\n');
                if nRep >= 5
                    idxPeaks = idxPeaks(1:5);
                else
                    idxPeaks = idxPeaks(1:nRep + 1);
                end
            else
                if length(idxPeaks) < nRep + 1
                    error('Not enough peaks found for %s', trial);
                end
                idxPeaks = idxPeaks(1:nRep + 1);
            end

            % Select the data to analyse
            Q = Q(models(iM).dofToShow, :);

            % Time normalisation
            for iT = 1:length(idxPeaks) - 1
                tp = Q(:, idxPeaks(iT):idxPeaks(iT+1));
                if resetToZero
                    tp = tp - tp(:, 1);  % Reset initial frame to zero
                end
                allQ(:, :, iT, iS, iM) = ...
                    interp1(linspace(0, 1, size(tp, 2)), tp', linspace(0, 1, nFrames), 'spline')';
            end

        end 
    end
end

