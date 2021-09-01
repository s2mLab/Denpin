% Ce script permet de reconstruire un essai en passant par matlab
function [Q, DIFF, V, A] = ReconstructTrial(recons, conf)
% ArgIn
% recons.reconsAlgo : 'QLD' ou 'kalman'
% recons.TOBS est les marqueurs classés par table2class
% recons.qinit est la solution initiale, S'il n'y en a pas, mettre cette variable
%       vide ou ne pas l'écrire
% recons.def est le fichier SomeDefinition. Si celui-ci n'est pas disponible, les
%       champs nécessaire sont : def.Tq, def.Rq avec def.Tq = [4:6] et def.Rq =
%       [1:3] le plus souvent
% recons.showRecons montre ou non la reconstruction : 0=pas de visu; 1=visu par
%       instant; 2=visu de chaque itération d'un instant
% conf est la variable de configuration dans le dossier de conf


% Selectionner les options de reconstruction
param = modelReconsParam(conf.model);

% remplir recons s'il manque des choses avec des valeurs par defaut
if ~isfield(recons, 'def')
    recons.def = readSomeDefinitionFile(conf.path.libPath);
end
recons = fillReconsStruct(recons, param, conf);

% Ajouter le path de reconstruction (librairie)
if exist('biorbd', 'file') ~= 3 % Si le MEX-File existe
    error('I could not find biorbd.mex* file!')
end
    
% Initiation des variables
if isempty(recons.qinit)
    Q = nan(param.NDDL,size(recons.TOBS,3));
else
    if size(recons.qinit,2) == 1
        Q = repmat(recons.qinit, [1,size(recons.TOBS,3)]);
    else
        Q = recons.qinit;
    end
end
V = nan(size(Q));
A = nan(size(Q));
DIFF = cell(length(param.qutilises),1);

for k = 1:length(param.qutilises)%% nombre d'etapes dans la reconstruction.
    fprintf('\t\t\tReconstruction no : %d\n',k);
    
    % Trouver les markers presents
    recons.mark = ~isnan(squeeze(recons.TOBS(1,:,:)));
    recons.mark = recons.mark & squeeze(recons.TOBS(1,:,:)) ~= 0;
    recons.mark(param.MarkFaux{k},:) = false;
    
    % Mettre les rotations et tranlations dans le bon ordre
    DOFidx = [];
    DOFidx = 1:param.NDDL;
    
    % Determiner les qinit pour cette recons
    recons.qinit = Q;
    recons.qinit(isnan(recons.qinit)) = 0.1;
	recons.qinit(DOFidx(param.qbloques{k}),:) = 0; % mettre les ddl bloques a 0.
    
    % qutilises pour cette recons
    recons.qutilises = false(param.NDDL,1);
    recons.qutilises(DOFidx(param.qutilises{k})) = true ;
    
    % Mettre les bounds si elles existent
    if isfield(param, 'lb')
        recons.lb = param.lb{k};
    else
        recons.lb = [];
    end
    if isfield(param, 'ub')
        recons.ub = param.ub{k};
    else
        recons.ub = [];
    end
    
    % Poids des markers
    recons.MarkW = param.MarkW;
    
    % Reconstruction   
    switch recons.reconsAlgo
        case 'QLD'
            [Qtp, DIFF{k}] = QLDRecons(recons);
            Q(recons.qutilises,:) = Qtp(recons.qutilises,:);
            Q(DOFidx(param.qbloques{k}),:) = 0;

        case 'kalman'
            recons.def.frequence = conf.frequence;
            [Qtp, DIFF{k}, V_tp, A_tp] = KalmanRecons(recons);
            %WithRef, TOBS, mark, MarkW,tp, qinit, def.Tq, def.Rq, param.UseEllips{k}, def.Ellipsoide, EllipsMarker, def, showRecons);
            
            Q(recons.qutilises,:) = Qtp(recons.qutilises,:);
            V(recons.qutilises,:) = V_tp(recons.qutilises,:);
            A(recons.qutilises,:) = A_tp(recons.qutilises,:);
            Q(DOFidx(param.qbloques{k}),:) = 0;
            V(DOFidx(param.qbloques{k}),:) = 0;
            A(DOFidx(param.qbloques{k}),:) = 0;
        otherwise
                error('Please select a proper reconstruction algorithm, ''QLD'' or ''kalman''');
    end
end