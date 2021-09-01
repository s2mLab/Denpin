function [conf, MS] = Anatomical_Method(conf, s, Mstat, MS, AnatomicalAlgo)
    % s est le numéro du segment actuel (enfant)
    fprintf(     'Anatomical CoR determination for segment %d\n',s);
    fprintf(conf.rid, 'Anatomical CoR determination for segment %d\n',s);

    r=conf.S(s).parent; % r est le numéro du segment parent
    
    
    
    %% Repères anatomiques pour determiner le CoR
    n = 0;
    for s2 = 1:s-1 % Trouver le nombre de markers avant ce segment
        n = n+conf.S(s2).nreal;
    end
    
    
    if nargin < 5
        AnatomicalAlgo = '';
    end
    
    if strcmpi(conf.S(s).name, 'arm') && islogical(AnatomicalAlgo)
        warning('Arm n''est plus directement envoyé à Rab dans le cas anatomique, svp remplacer par le tag ''anatomicalRab''')
        AnatomicalAlgo = 'anatomicalRab';
    end
        
        
    
    if strcmpi(AnatomicalAlgo, 'anatomicalRab')
        % Traitement spécifique pour le bras (17% de la longueur entre les
        % épicondyles et le marqueur AC... Épicondyles=> markeurs demandés, AC => CoR du parent)
        if numel(conf.S(s).JointAnatomicalMarker)==2
            AC = MS(1:3,conf.S(r).O,:,r);
        elseif numel(conf.S(s).JointAnatomicalMarker)==3
            AC = MS(1:3,conf.S(s).JointAnatomicalMarker(3),:,s);
        end
        
        epi = mean(Mstat(:,n+conf.S(s).JointAnatomicalMarker(1:2),:),2);
        CoR = AC + .17*(epi-AC);
        
    elseif strcmpi(AnatomicalAlgo, 'anatomicalBell')
        % Traitement spécifique pour la hanche par Bell
        % (http://www.sciencedirect.com/science/article/pii/0167945789900201)
        % we found that the three-dimensional (3-D) HJC location in adults 
        % (expressed as a percentage of the distance between the anterior superior iliac spines (ASIS)) 
        % was 30% distal, 14% medial, and 22% posterior to the ASIS, and
        % predicted the HJC location to within 3.3 cm of the true location with 95% certainty. 
        distASIS = sqrt(sum(diff(Mstat(:,conf.S(s).JointAnatomicalMarker,:),1,2).^2,1));
        
        % Trouver le repère bassin
        RA=nan(4,4,size(MS,3),conf.segments);
        TAGS=zeros(size(MS));
        conf2 = conf;
        conf2.opt.plot_auto = false;
        RA = getRAandTAGS(conf2, MS, 1, RA, TAGS);
        RPelvis = RA(:,:,:,1);
        
        % Placer le centre au coin (ASISl ou ASISr)
        % Si le trochanter est à droite, on s'occupe de la droite, sinon de
        % la gauche
        if strcmp(conf.lateralite, 'd')
            RPelvis(1:3,4,:) = Mstat(:,conf.S(s).JointAnatomicalMarker(2),:);
        else
            RPelvis(1:3,4,:) = Mstat(:,conf.S(s).JointAnatomicalMarker(1),:);
            % Opposer l'axe x (système d'axe main gauche)
            RPelvis(:,1,:) = -RPelvis(:,1,:);
        end
        
        CoR = multiprod(RPelvis, [-.14*distASIS;-.22*distASIS;-.3*distASIS;ones(1,1,length(distASIS))]);
        CoR = CoR(1:3,:,:);
        
    else
        % Traitement générique : moyenne des markeurs demandés
        CoR = mean(Mstat(:,n+conf.S(s).JointAnatomicalMarker,:),2);
    end
     
     
    %% dans le statique
    % replace les CoR
    pp=1;

    % store CoR in static
    MS(1:3,conf.S(r).n+pp,:,r)=CoR; 
    MS(1:3,conf.S(s).n+pp,:,s)=CoR; 

    % Stocker le nom des markers
    CoR_Name = sprintf('CoR_%s_%s',conf.S(r).name, conf.S(s).name);
    conf.S(r).MarkName = [conf.S(r).MarkName, CoR_Name];
    conf.S(s).MarkName = [conf.S(s).MarkName, CoR_Name];
    
    % Affichage d'informations
    fprintf(     '\tCoR/AoR dans proximal a colonne %d\n',conf.S(r).n+pp);
    fprintf(conf.rid, '\tCoR/AoR dans proximal a colonne %d\n',conf.S(r).n+pp);

    fprintf(     '\tCoR/AoR dans distal   a colonne %d\n',conf.S(s).n+pp);
    fprintf(conf.rid, '\tCoR/AoR dans distal   a colonne %d\n',conf.S(s).n+pp);

    % Plot du CoR dans la figure principale
    if conf.opt.plot_auto
        figure(conf.h.f1)
        hold on
        CoRm = mean(CoR,3);
        plot3(CoRm(1,:),CoRm(2,:),CoRm(3,:), 'bo'); 
    end
    
    % Augmenter le nombre de markers
    conf.S(r).n = conf.S(r).n+pp; 
    conf.S(s).n = conf.S(s).n+pp; 
    
    % Print d'informations
    fprintf(     '\n\t %s passe de %d a %d marqueurs\n',    conf.S(r).name, conf.S(r).n-pp, conf.S(r).n);
    fprintf(conf.rid, '\n\t %s passe de %d a %d marqueurs\n',    conf.S(r).name, conf.S(r).n-pp, conf.S(r).n);
    fprintf(     '  \t %s passe de %d a %d marqueurs\n\n\n',conf.S(s).name, conf.S(s).n-pp, conf.S(s).n);
    fprintf(conf.rid, '  \t %s passe de %d a %d marqueurs\n\n\n',conf.S(s).name, conf.S(s).n-pp, conf.S(s).n);
end



