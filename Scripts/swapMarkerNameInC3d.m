clc
clear
close all

markerNamesToChange = {{'brace1', 'LE'}, {'brace2', 'ME'}};
rootFolder = '/home/pariterre/Programmation/CAST/Data/RAW';
subjects = {'Subject1', 'Subject2', 'Subject3', 'Subject4', 'Subject5', 'Subject6', 'Subject7', 'Subject8'};
folders = {'Brace', 'Brace/MODEL'};


for iS = 1:length(subjects)
    for iF = 1:length(folders)
        pathToFolder = [rootFolder '/' subjects{iS} '/' folders{iF}];
        files = dir([pathToFolder '/*.c3d']);
        for iFile = 1:length(files)
            pathToFile = [pathToFolder '/' files(iFile).name];
            c = ezc3dRead(pathToFile);
            n = 0; % Number of changes done
            for i = 1:c.parameters.POINT.USED.DATA
                for j = 1:length(markerNamesToChange)
                    idx = strfind(c.parameters.POINT.LABELS.DATA{i}, markerNamesToChange{j}{1});
                    if ~isempty(idx)
                        prefix = c.parameters.POINT.LABELS.DATA{i}(1:idx-1);
                        c.parameters.POINT.LABELS.DATA{i} = [prefix markerNamesToChange{j}{2}];
                        n = n + 1;
                    end
                end
            end
            fprintf('%d markers were changed for %s in file: %s\n', n, subjects{iS}, pathToFile);
            ezc3dWrite(pathToFile, c);
        end
    end
end
