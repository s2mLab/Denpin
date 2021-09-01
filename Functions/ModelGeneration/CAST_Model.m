%%PROGRAMME GENERANT AUTOMATIQUEMENT LES FICHIERS POUR RECONSTRUCTION
close all
conf.h.f1 = figure; hold on; axis equal

%%Chargement statique
s=0;
conf.segments = length(conf.S);
Mstat = LoadViconFile('static',conf);
if isempty(Mstat)
    warning('Could not load static trial for model %d in %s', conf.model, conf.file.root)
    return;
end
Mstat = Mstat(:, :, 1:5);

% Trouver matrice rotation local de chaque segment et la position des
% marqueurs
[R_t0, MS] = getLocalSegment(conf, Mstat);

% [n0,p0,q0,r0] = size(MS);


%% CALCUL des CoR
conf.S(1).nreal = conf.S(1).n;

for s=2:conf.segments  
    conf.S(s).nreal = conf.S(s).n; % Mettre dans une autre variable le nombre de marker qui va changer
    if ~isempty(conf.S(s).Joint)
        
        switch conf.S(s).JointDeterminationType
            case 'functional'
                [conf, MS] = SCoRE_Method(conf, s, R_t0, MS);
            case 'gamage'
                [conf, MS] = Gamage_Method(conf, s, R_t0, MS);
            case 'anatomical'
                % Ajouter false après que le portage ait été fait
                [conf, MS] = Anatomical_Method(conf, s, Mstat, MS);
            case 'anatomicalRab'
                [conf, MS] = Anatomical_Method(conf, s, Mstat, MS, 'anatomicalRab');

            otherwise 
                error('conf.S(%d).JointDeterminationType = %s is invalid', s, conf.S(s).JointDeterminationType)
        end
    end
    
            
end
plot3(nanmean(Mstat(1,:,1), 3), nanmean(Mstat(2,:,1), 3), nanmean(Mstat(3,:,1), 3), 'k.')


%% Boucle Calcul Reperes anatomique + TAGS
RA=nan(4,4,size(MS,3),conf.segments);
TAGS=zeros(size(MS));
for s=1:conf.segments
    [RA, TAGS] = getRAandTAGS(conf, MS, s, RA, TAGS);
end

%% Validation visuelle de l'expérimentateur
figure(conf.h.f1);
% if ~conf.opt.run_auto, fprintf('\n Check the result and then press a key... \n'); pause; end

%% Sauvegarde d'éléments intéressants
save([conf.DirOut 'confg.mat'],'conf')
figure(conf.h.f1); view(180,40)
NewName = [conf.DirOut conf.subject.pseudo int2str(conf.model) '.png']; saveas(conf.h.f1, NewName);
NewName = [conf.DirOut conf.subject.pseudo int2str(conf.model) '.fig']; saveas(conf.h.f1, NewName);
fprintf(     '\n%s  saved\n',NewName);
fprintf(conf.rid, '\n%s  saved\n',NewName);

%% Générer le modèle
GenerateS2MconfModel(conf, RA, TAGS);

% Faire pop la figure 1
figure(conf.h.f1)

