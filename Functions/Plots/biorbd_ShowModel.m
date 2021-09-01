function h = S2M_rbdl_ShowModel(m, varargin)
% Fonction servant à afficher un modèle S2M_rbdl m à la position Q; h est
% un handler sur les graphiques pour updater une position. D'ordinaire la
% fonction s'appelle par S2M_rbdl_ShowModel(m, Q, h, ...)
%
% Typiquement, S2M_rbdl_ShowModel est appelé une première fois uniquement
% avec m et les options (voir plus bas)  et le handler est récupéré. 
% Ensuite, la fonction est appelé avec m, Q et handler et les paramètres
% sont modifiés si besoin.
% Options : S2M_rbdl_ShowModel(..., 'option', valeur)
%         nodes     = [true] ou false; Afficher les mesh
%         facecolor = ['w'], couleur ou RBG; Changer la couleur des faces du mesh
%         rt        = [true] ou false; Afficher les matrices de rototrans 
%         tags      = [true] ou false; Afficher les marqueurs
%         tagsPlotOpt  = {'option', valeur}; Options à transferer à plot
%         com       = [true] ou false; Afficher le centre de masse global
%         comi      = [true] ou false; Afficher les centres de masses segmentaires
%         contact   = [true] ou false; Afficher les points de contact
%         muscle    = [true] ou false; Afficher les muscles
%         wrap      = [true] ou false; Afficher les objets de contournement
%         imu       = [true] ou false; Afficher les centrales inertielles
%         imucolor  = ['rgb'], couleur; Changer la couleur des centrales
%         view      = [azimut elevation]; Tourner autours du modèle


    % Si aucun Q n'est envoyé, préparer tout de même tout avec NaN
    if nargin < 2
        Q = nan(biorbd('nQ', m),1);
    elseif isnumeric(varargin{1})
        Q = varargin{1};
        varargin = varargin(2:end);
    else
        Q = nan(biorbd('nQ', m),1);
    end
    
    % Récupérer le parent
    optionChanged = false;
    if ~isempty(varargin) && isstruct(varargin{1})
        first = false;
        h = varargin{1};
        parseur = 2:2:length(varargin);
    else
        first = true;
        h = [];
        parseur = 1:2:length(varargin);

        % Mettre les valeurs par défaut
        h.showNodes = true;
        h.showRT = true;
        h.showT = true;
        h.showUseRemoveAxes = true;
        h.showImu = true;
        h.showCoM = true;
        h.showCoMi = true;
        h.showContact = true;
        h.showMuscles = true;
        h.showWrap = false;
        optionChanged = true;
    end
    
    % Déclaration de tous les éléments nécessaires
    meshNodes = biorbd('mesh', m, Q(:,1)); % Tous les nodes du meshing par segments
    meshPatch = biorbd('patch', m); % Tous les vertices du meshing par segments
    RT = biorbd('globalJCS', m, Q(:,1)); % Systmème d'axes par segments
    T = biorbd('segmentsMarkers', m, Q(:,1),h.showUseRemoveAxes); % Position des marqueurs par segments
    imu = biorbd('imu', m, Q(:,1)); % Systmème d'axes par segments
    com = biorbd('com', m, Q(:,1)); % Position du CoM global
    comi = biorbd('segmentCom', m, Q(:,1)); % Position des CoM par segments
    C = biorbd('contacts', m, Q(:,1)); % Position des contacts
    [M, wrap] = biorbd('musclePoints', m, Q(:,1)); % Position des nodes articulaires et des wrapping objects
    

    % Initiation des plots si c'est la première fois
    if nargin < 3 || first
        hold on
        h.axesHandler = gca;

        % Handler sur les mesh
        for i=1:length(meshNodes)
            if ~isempty(meshPatch{i})
                h.meshPatch{i} = patch('faces', meshPatch{i}', 'vertices', nan(size(meshNodes{i}')), 'facecolor', 'w');
            else
                h.meshPatch{i} = -1;
                h.meshVertices{i} = plot3d(nan(3,1), 'k-');
            end
        end

        % Handler sur les systèmes d'axes
        for i=1:size(RT,3)
            h.RT{i} = plotAxes(nan(4));
        end

        for i=1:size(imu,3)
            h.imu{i} = plotCentrale(nan(4));
        end

        % Handler sur les Tags et les traits
        for i = 1:length(T)
            for j = 1:size(T{i},2)
                h.Tags{i}.traits{j} = plot3d(nan(3,1), 'b--.');
            end
        end

        % Handler sur le CoM global
        h.CoM = plot3d(nan(3,1), 'k.', 'markersize', 25);

        % Handler sur les CoM segmentaires
        h.CoMi = plot3d(nan(3,1), 'k.', 'markersize', 21);

        % Handler sur les contacts
        h.contacts = plot3d(nan(3,1), 'g.', 'markersize', 21);

        % Handler sur les muscles
        for i = 1:length(M)
            h.muscles{i}.traits = plot3d(nan(3,1), 'r-');
            h.muscles{i}.points = plot3d(nan(3,1), 'r.');
        end
    end


    for i = parseur
        if ~ischar(varargin{i})
            error('(''Paramètre'',''Valeur'' doit être respecté');
        end
        if length(varargin) < i+1
            error('La valeur pour %s n''est pas présente', varargin{i});
        end

        if strcmpi(varargin{i}, 'nodes')
            h.showNodes = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'rt')
            h.showRT = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'tags')
            h.showT = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'useRemoveAxes')
            if varargin{i+1} ~= h.showUseRemoveAxes % Si on inverse le tag
                h.showUseRemoveAxes = varargin{i+1};
                T = biorbd('segmentsMarkers', m, Q(:,1),h.showUseRemoveAxes); % Position des marqueurs par segments
            end
        elseif strcmpi(varargin{i}, 'tagsplotopt')
            for iT = 1:length(T)
                for jT = 1:size(T{iT},2)
                    set( h.Tags{iT}.traits{jT}, varargin{i+1}{:});
                end
            end
        elseif strcmpi(varargin{i}, 'imu')
            h.showImu = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'com')
            h.showCoM = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'comi')
            h.showCoMi = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'contact')
            h.showContact = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'muscle')
            h.showMuscles = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'wrap')
            h.showWrap = varargin{i+1};
            optionChanged = true;
        elseif strcmpi(varargin{i}, 'view')
            view(varargin{i+1})
        elseif strcmpi(varargin{i}, 'facecolor')
            for j=1:length(meshNodes)
                set(h.meshPatch{j}, 'facecolor', varargin{i+1});
            end
        elseif strcmpi(varargin{i}, 'imucolor')
            for j=1:length(h.imu)
                plotCentrale(h.imu{j}, 'color', varargin{i+1});
            end
        else
            error('%s n''est pas une propriété', varargin{i});
        end
    end





% Update des graphiques
% Affichage du corps

for i=1:length(meshNodes)
    if h.showNodes
        if h.meshPatch{i} ~= -1
            set(h.meshPatch{i}, 'vertices', meshNodes{i}')
        else
            plot3d(h.meshVertices{i}, meshNodes{i});
        end
    elseif optionChanged
        if h.meshPatch{i} ~= -1
            set(h.meshPatch{i}, 'vertices', nan(3,1))
        else
            plot3d(h.meshVertices{i},  nan(3,1));
        end
    end
end

% Affichage des systèmes d'axe
for i=1:size(RT,3)
    if h.showRT
        plotAxes(RT(:,:,i,1),h.RT{i});
    elseif optionChanged
        plotAxes(nan(4),h.RT{i});
    end
end

for i=1:size(imu,3)
    if h.showImu
        plotCentrale(imu(:,:,i), h.imu{i});
    elseif optionChanged
        plotCentrale(nan(4), h.imu{i})
    end
end

% Affichage des tags 
for i = 1:length(T)
    for j = 1:size(T{i},2)
        if h.showT
            plot3d(h.Tags{i}.traits{j}, [comi(:,i) T{i}(:,j)]);
        elseif optionChanged
            plot3d(h.Tags{i}.traits{j}, nan(3,1));
        end
    end
end

% Affichage du centre de masse global
if h.showCoM
    plot3d(h.CoM, com);
elseif optionChanged
    plot3d(h.CoM, nan(3,1));
end

% Affichage des centre de masse segmentaire
if h.showCoMi
    plot3d(h.CoMi, comi);
elseif optionChanged
    plot3d(h.CoMi, nan(3,1));
end

% Afficher les contacts
if h.showContact
    plot3d(h.contacts, C);
elseif optionChanged
    plot3d(h.contacts, nan(3,1));
end

% Afficher les muscles
for i = 1:length(M)
    if h.showMuscles
        plot3d(h.muscles{i}.traits, M{i})
        plot3d(h.muscles{i}.points, M{i})
    elseif optionChanged
        plot3d(h.muscles{i}.traits, nan(3,1));
        plot3d(h.muscles{i}.points, nan(3,1));
    end
end

% Afficher les wrapping objects
if h.showWrap
    for i = 1:size(wrap,1)
        if strcmpi(wrap{i,1}, 'cylinder')
            [xc,yc,zc] = cylinder(wrap{i,3});
            zc(2,:) = wrap{i,4}; % Set de la longueur
            c1 = wrap{i,2} * [xc(1,:); yc(1,:); zc(1,:); ones(1,size(xc,2))];
            c2 = wrap{i,2} * [xc(2,:); yc(2,:); zc(2,:); ones(1,size(xc,2))];
            xc = [c1(1,:); c2(1,:)];
            yc = [c1(2,:); c2(2,:)];
            zc = [c1(3,:); c2(3,:)];
            surf(xc,yc,zc)
        else
            warning('Can''t recognize the wrapping object');
        end
        plotAxes(wrap{i,2});
    end
end

    if nargout < 1
        clear h 
    end

end
