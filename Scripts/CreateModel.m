clear;
close all
clc
addpath(genpath('/home/pariterre/Programmation/CAST/Functions'));

models = {'Subject1' 'Subject2' 'Subject3' 'Subject4' 'Subject5' 'Subject6' 'Subject7' 'Subject8'};
subfolders = {'PreSurgery', 'SkinAndBrace', 'Brace'};
modelnumbers = {1, [1 2 12 21 101 102], [2 3 23 32]};
% models = {'Subject1'}; % 'Subject2' 'Subject3' 'Subject4' 'Subject5' 'Subject6' 'Subject7' 'Subject8'};
subfolders = {'SkinAndBrace'};
modelnumbers = {[101 102]};
DName = '/home/pariterre/Programmation/Denpin/Data/config';

for iModel = 1:length(models)
    for iSub = 1:length(subfolders)
        for iMN = 1:length(modelnumbers{iSub})
            fclose('all');clc;close all;
            clear conf

            conf.opt.run_auto   = 0; %for closing the figures 
            conf.opt.plot_auto  = 1; %for ploting
            conf.opt.reconstruction_auto = 0;    %for automatic reconstruction (not implemented)

            WName = pwd; %working directory
            conf.modelType = 'CAST';
            conf = setPaths(conf);

            FName = models{iModel};
            cd(DName)
            conf.subject.pseudo = FName; %execute les fichiers config

            conf.model = modelnumbers{iSub}(iMN); 
            conf.subfolder = subfolders{iSub};

            cd('./GENERIC');
            eval('conf_common');
            eval(sprintf('conf_model_%d', conf.model));
            eval('conf_common2');

            cd(WName) %retour dans le dossier de travail
            conf.path.libPath = conf.DirOut;
            conf.file.root= conf.file.dir;

            if size(dir(conf.file.dir),1)>2
                fprintf('Currently generating\n\tsubject: %s\n\t\tfolder: %s\n\t\tModel number: %d\n', conf.subject.pseudo, conf.subfolder, conf.model)
                if exist(conf.DirOut,'dir')
                    rmdir(conf.DirOut, 's');
                end
                mkdir(conf.DirOut); 
                    fprintf(     'Dossier %s créé',conf.DirOut); 

                % Genere le fichier de rapport
                conf.rid = fopen(sprintf('%s_MOD%d.report',fullfile(conf.DirOut, FName(1:end-2)),conf.model),'w+');
                fprintf(    'Repertoire: %s\n', DName);	fprintf(    'Fichier de configuration: %s', FName);
                fprintf(conf.rid,'Repertoire: %s\n', DName);	fprintf(conf.rid,'Fichier de configuration: %s', FName);
                CAST_Model;
                fclose(conf.rid);
                
                fprintf('\n\n');
                fprintf('Currently generating\n\tsubject: %s\n\t\tfolder: %s\n\t\tModel number: %d\n', conf.subject.pseudo, conf.subfolder, conf.model)
                fprintf('Press a key to continue..\n');
                pause
            end
        end
    end
end
