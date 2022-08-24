d2r=180/pi; %convertir degres en radians
conf.file.ext='.c3d';
conf.file.dir = sprintf('%s/../../RAW/%s/%s/MODEL/',pwd, conf.subject.pseudo,conf.subfolder);
if ~exist('LibPath', 'var')
    conf.DirOut=sprintf('%s/../../Lib/%s/%s/Model_%d/', pwd, conf.subject.pseudo,conf.subfolder,floor(conf.model));
else
    conf.DirOut=sprintf('%s%s/%s/Model_%d/', LibPath, conf.subject.pseudo,conf.subfolder,floor(conf.model));
end
conf.DirIn ='../Lib/source/';% ../ pour remonter d'un dossier
conf.DirFunctions = '../functions_matlab';
conf.DELIMITER = ',';
conf.HEADERLINES = [11,1;5,2;11,1]; %read the file at line headerlines+1  (premi�re ligne : Workstation, 2i�me Nexus
conf.frequence=100;%frequence acquisition
conf.stick = []; 

if floor(conf.model) == 1 
    % SkinAndBrace model: Scapula/Humerus using skin markers without the pins 
    conf.MarkName = {'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1',...1:8
                     'Hu1','Hu2','Hu3','Hu4','Hu5','LE','ME','PFA','DFA','RS','US', 'brace1','brace2','brace3','brace4','brace5','brace6'...9:25
                     }; %sans triade

elseif floor(conf.model) == 2
    % Pins model: Scapula/Humerus using pins markers without the skin markers
    conf.MarkName = {'ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4','AA','TS','AI','ACJ1',...1:8
                     'HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4','LE','ME' ...9:14
                     }; %sans triade

elseif floor(conf.model) == 3
    % Brace model: Scapula/Humerus using brace markers without the pins 
    conf.MarkName = {'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1',...1:8
                     'LE','ME','brace3','brace4','brace5',...9:13
                     }; %sans triade

elseif floor(conf.model) == 12
    % Model 1 with the (unused) pins markers from 2 (only for vizualisation)
    conf.MarkName = {'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1','ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4',...1:12
                     'Hu1','Hu2','Hu3','Hu4','Hu5','LE','ME','PFA','DFA','RS','US', 'brace1','brace2','brace3','brace4','brace5','brace6','HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4'...13:33
                     }; %sans triade

elseif floor(conf.model) == 21
    % Model 2 with the (unused) SkinAndBrace markers from 1 (only for vizualisation)
    conf.MarkName = {'ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4','AA','TS','AI','ACJ1','ScapClus1','ScapClus2','ScapClus3','ScapClus4',...1:12
                     'HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4','LE','ME','Hu1','Hu2','Hu3','Hu4','Hu5','PFA','DFA','RS','US', 'brace1','brace2','brace3','brace4','brace5','brace6' ...13:33
                     }; %sans triade

elseif floor(conf.model) == 23
    % Model 2 with the (unused) Brace markers from 3 (only for vizualisation)
    conf.MarkName = {'ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4','AA','TS','AI','ACJ1','ScapClus1','ScapClus2','ScapClus3','ScapClus4',...1:12
                     'HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4','LE','ME','brace3','brace4','brace5' ...13:21
                     }; %sans triade

elseif floor(conf.model) == 32
    % Model 3 with the (unused) pins markers from 2 (only for vizualisation)
    conf.MarkName = {'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1','ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4',...1:12
                     'LE','ME','brace3','brace4','brace5','HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4',...13:21
                     }; %sans triade
                 
elseif floor(conf.model) == 101
    % SkinAndBrace model: Thorax/Scapula/Humerus using skin markers without the pins 
    conf.MarkName = {'T8','C7','IJ','PX',...1:4
                    'ScapClus1','ScapClus2','ScapClus3','ScapClus4','AA','TS','AI','ACJ1',...5:12
                     'Hu1','Hu2','Hu3','Hu4','Hu5','LE','ME','PFA','DFA','RS','US', 'brace1','brace2','brace3','brace4','brace5','brace6'...13:29
                     }; %sans triade
                 
elseif floor(conf.model) == 102
    % SkinAndBrace model: Thorax/Scapula/Humerus using skin markers without the pins 
    conf.MarkName = {'T8','C7','IJ','PX',...1:4
                    'ScapulaPin1','ScapulaPin2','ScapulaPin3','ScapulaPin4','AA','TS','AI','ACJ1',...5:12
                     'HumerusPin1','HumerusPin2','HumerusPin3','HumerusPin4','LE','ME' ...13:18
                     }; %sans triade
else 
    error('Wrong choice of model!')
end
