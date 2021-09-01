function conf = generateS2MModel(conf)
    % Generer un fichier de mod�le pour S2M_rbdl
    fprintf('Generating Model.s2mMod file from conf file\n')

    % Load des donnees conf
    % Determination des path et ouverture des librairies
    conf = setPaths(conf);
    
    % Fichier dans lequel sera place le modele
    name=[conf.path.libPath '/Model.s2mMod'];%[conf.subject.firstname conf.subject.name '.maple'];
    fid = fopen(name, 'w+');

    % Numéro de version
    fprintf(fid, 'version\t%d\n', 1);
    fprintf(fid, '\n');
    
    % Définition générale
    seq_trans = 'xyz';
    
    % GL est la matrice de RTs dans le global (RT étant les RT locaux)
    GL = nan(4,4,length(conf.pis));
    for i = 1:length(conf.pis)
        if i~=1
            GL(:,:,i) = GL(:,:,conf.S(i).parent) * conf.pis(i).RT;
        else
            GL(:,:,i) = conf.pis(i).RT;
        end
    end
    
    % Position des marqueurs dans le global
    T = conf.T;
        
    % Marquer les segments
    param = modelReconsParam(conf.model);
    if length(param.MarkFaux) > 1
        param.MarkFaux2 = intersect(param.MarkFaux{:});
    else
        param.MarkFaux2 = param.MarkFaux{:};
    end
    
    % Ecrire ce qui concerne chaque segment
    for i=1:length(conf.S) 
        % Ecriture de l'entete du segment
        fprintf(fid, '// Informations about %s segment\n', conf.S(i).name);
        fprintf(fid, '\t// Segment\n');
        
        % Nom du segment
        fprintf(fid, '\tsegment\t%s\n', conf.S(i).name);
        
        % Parent du segment
        if i~= 1
            fprintf(fid, '\t\tparent\t%s\n', conf.S(conf.S(i).parent).name);
        end
        
        % Passage du parent a l'enfant
        fprintf(fid, '\t\tRT\n');
        if i == 1
            GL_TP = GL(:,:,i);
        else
            GL_TP = invR(GL(:,:,conf.S(i).parent))*GL(:,:,i);
        end
        for j=1:4
            fprintf(fid, '\t\t'); 
            fprintf(fid, '\t%1.10f', GL_TP(j,:));
            fprintf(fid, '\n');
        end
        
        % sequence DoF en trans et rot
        if sum(conf.S(i).dof(4:6)>0)
            [~,~,idx] = intersect(1:param.NDDL, conf.S(i).dof(4:6));
            if ~isempty(idx)
                fprintf(fid, '\t\ttranslations\t%s\n', seq_trans(idx));
            end
        end
        if sum(abs(conf.S(i).dof(1:3)) > 0)
            [~,~,idx] = intersect(1:param.NDDL, abs(conf.S(i).dof(1:3)));
            if ~isempty(idx)
                fprintf(fid, '\t\trotations\t%s\n', conf.S(i).seq(idx));
            end
        end
        
        % Fin du segment
        fprintf(fid, '\tendsegment\n');
        fprintf(fid, '\n');
        
        % Placement des markers
        fprintf(fid, '\t// Markers\n');
        nPreviousMark = sum([conf.S(1:i).n])-sum(conf.S(i).n);
        if ~isfield(conf, 'MarkName')
            error('conf.MarkName should exist');
        end
        for j=1:conf.S(i).n
            Tp = T(j+nPreviousMark, :);  % Dans le repère local %invR(GL(:,:,i)) * T(j+nPreviousMark, :)';
            fprintf(fid, '\tmarker\t%s\n', conf.MarkName{j+nPreviousMark});
            fprintf(fid, '\t\tparent\t%s\n', conf.S(i).name);
            fprintf(fid, '\t\tposition');
                fprintf(fid, '\t%1.10f', Tp);
                fprintf(fid, '\n');
            if sum(j+nPreviousMark == param.MarkFaux2) % Si le marqueur ne fait pas parti de markerfaux (donc pas un markeur technique)
                fprintf(fid, '\t\ttechnical 0\n');
            else
                fprintf(fid, '\t\ttechnical 1\n');
            end
            if isfield(conf, 'axesToRemove')
                if ~isempty(conf.axesToRemove{j+nPreviousMark})
                    fprintf(fid, '\t\taxesToRemove\t%s\n', conf.axesToRemove{j+nPreviousMark});
                end
            end
            fprintf(fid, '\tendmarker\n');

        end
        fprintf(fid, '\n\n');
    end

    fclose(fid);

end
