clear;
close all
clc
addpath(genpath('../Functions'));

% Options
showRecons = false; % true => montre la reconstruction en temps reel; false => ne montre rien
saveResults = true; % true => enregistre les resultats 
reconsAlgo = 'kalman'; % QLD; kalman; 
useOldRecons = true; % true => Ne reconstruit pas ce qui est deja reconstruit
folderNameToSave = 'CAST'; % Nom de la personne qui utilise ce script

% Tous les pseudo, 
	pseudos = {'Subject1', 'Subject2', 'Subject3', 'Subject4', 'Subject5', 'Subject6', 'Subject7', 'Subject8', };

% Tous les dossiers a reconstruire, 
	% si vide ou inexistant, la reconstruction se fait sur tous les dossiers
 	subfolders = {'SkinAndBrace'};  % 'PreSurgery', 'SkinAndBrace', 'Brace', }; 
    
% Num�ro du mod�le
	modelnumbers = {[101.1, 102]};  % [1.0 1.1 1.2 1.3 1.4 1.5], [1.0, 1.1, 1.2, 1.3 1.4 1.5 2.0], [2.0 3.0]};



%*** NE PAS MODIFIER ***%
% Récupérer des informations importantes
conf.modelType = 'CAST';
conf = setPaths(conf);

% Sauvegarde du dossier courant
wd = pwd;

% Dossier de donnees
SavePath = ['../Results/' folderNameToSave '/'];

% Position des T et des R
recons.def.Tq=1:3;
recons.def.Rq=4:6;

% Autres
recons.showRecons = showRecons;

% Reconstruction de tout ce qu'il y a dans pseudo 
for ipseudo = 1:length(pseudos)
	pseudo = pseudos{ipseudo};
    fprintf('\n\nSubject : %s\n', pseudo);
    conf.subject.pseudo =pseudo;
    conf.exp.system = 'Nexus';
    
    for iSub = 1:length(subfolders)
        for iM = 1:length(modelnumbers{iSub})
            fprintf('\tModel number: %1.1f\n', modelnumbers{iSub}(iM));
            conf.model = modelnumbers{iSub}(iM);
            conf.subfolder = subfolders{iSub};
            run([conf.path.basePath '/config/GENERIC/conf_common.m'])

            conf.path.libPath = conf.DirOut;
            if ~isfolder(conf.path.libPath)
               continue
            end

            conf = setPaths(conf);
            cd(wd);
            dossier = subfolders{iSub};
            fprintf('\tFolder: %s\n', dossier);
            SaveDir = [SavePath '/' pseudo '/' dossier '/'];
            if ~exist(SaveDir, 'dir')
                mkdir(SaveDir)
            end
            RawPath = [conf.path.basePath '/RAW/' pseudo '/' dossier];
            if exist(RawPath,'dir') % S'assurer que l'on "cd" dans un dossier
                files = dir([RawPath '/*.c3d']);

                for iFiles = 1:length(files)
                    close all
                    fprintf('\tFile: %s\n', files(iFiles).name);

                    % Ouvrir l'essai
                    recons.TOBS = OrgData([RawPath filesep() files(iFiles).name],conf,false);
                    recons.TOBS = table2class(recons.TOBS)/1000;


                    % Choix du type de reconstruction
                    switch reconsAlgo 
                        case 'QLD'
                            % Test si le fichier existe déjà
                            if useOldRecons && exist(sprintf('%s%s_MOD%1.2f_%s.Q1',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo),'file')
                                fprintf('\t\tFichier déjà reconstruit par QLD trouvé, aucune reconstruction nécessaire\n\n')
                                continue % Passer au prochain fichier
                            end

                            % QLD
                            recons.reconsAlgo = 'QLD';
                            [Q1, ER1] = ReconstructTrial(recons, conf);
                        case 'kalman'
                            % Test si le fichier existe déjà
                            if useOldRecons && exist(sprintf(sprintf('%s%s_MOD%1.2f_%s.Q2',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo)),'file')
                                fprintf('\t\tFichier déjà reconstruit par kalman trouvé, aucune reconstruction nécessaire\n\n')
                                continue % Passer au prochain fichier
                            end

                            % Kalman filter
                            recons.reconsAlgo = 'kalman';
                            [Q2, ER2] = ReconstructTrial(recons, conf);
                    end

                    if saveResults
                        if exist('Q1', 'var')
                            save(sprintf('%s%s_MOD%1.2f_%s.Q1',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo), 'Q1');
                            save(sprintf('%s%s_MOD%1.2f_%s.E1',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo), 'ER1');
                        end
                        if exist('Q2', 'var')
                            save(sprintf('%s%s_MOD%1.2f_%s.Q2',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo), 'Q2');
                            save(sprintf('%s%s_MOD%1.2f_%s.E2',SaveDir,files(iFiles).name(1:end-4),conf.model,pseudo), 'ER2');
                        end
                    end
                    fprintf('\n');
                end
            end
        end
    end

end