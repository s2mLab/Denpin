function GenerateS2MconfModel(conf, RA, TAGS)
    % Generate data.maple

    name=[conf.DirOut 'confS2M.m'];%[conf.subject.firstname conf.subject.name '.maple'];   
    fid=fopen(name,'w+');
    fprintf(fid,['%% Author(s)\t: Pariterre\n'...
                    '%% Date : 24/01/2014 \n']);

    fprintf(fid,'\n \n%% System Characteristics' );
    fprintf(fid,['\n%% Number of solids  = %d \n'...
                   '%% Number of degrees of freedom = %d \n'...
                   '%% Number of real markers = %d \n'], ...
                   conf.segments,conf.dof, length(conf.MarkName));

    % Calculer les matrices de passages
    GL_tp = nan(4,4,size(RA,4));
    for i = 1:size(RA,4)
%         try 
        GL_tp(:,:,i) = averageRT(RA(:,:,:,i));
%         catch Error_ici
%             GL_tp(:,:,i) = eye(4);
%         end
    end
    
    fprintf(fid,'\n \n%% Segments');

    for s=1:conf.segments                                               
        fprintf(fid,'\n%% %d \t %s ',s,conf.S(s).name);
    end

    fprintf(fid,'\n\n%% Mass (uncomment when mass is known)');
    for s=1:conf.segments           
        if isfield(conf, 'pis') && ~isempty(conf.pis(s).mass)
            fprintf(fid,' \nconf.pis(%d).mass \t =  %1.2f; ',s,conf.pis(s).mass);
        end
    end

    fprintf(fid,'\n\n%% Center of Mass Location (uncomment when com is known)');
    for s=1:conf.segments             
        if isfield(conf, 'pis') && ~isempty(conf.pis(s).com)
            com_tp = mean(conf.pis(s).com,3);
            fprintf(fid,'\nconf.pis(%d).com \t = [%1.6f, %1.6f, %1.6f ]; ',s,com_tp(1), com_tp(2), com_tp(3));
        end
    end

    fprintf(fid,'\n \n%% Inertia (uncomment when inertia is known)');
    for s=1:conf.segments         
        if isfield(conf, 'pis')
            if isfield(conf.pis, 'I') && ~isempty(conf.pis(s).I)
                fprintf(fid,' \nconf.pis(%d).inertia \t = [%1.6f, %1.6f, %1.6f; %1.6f, %1.6f, %1.6f; %1.6f, %1.6f, %1.6f ]; ',s,conf.pis(s).I(1,1), conf.pis(s).I(1,2), conf.pis(s).I(1,3), conf.pis(s).I(2,1), conf.pis(s).I(2,2), conf.pis(s).I(2,3), conf.pis(s).I(3,1), conf.pis(s).I(3,2), conf.pis(s).I(3,3));
            elseif isfield(conf.pis, 'xx') && isfield(conf.pis, 'yy') && isfield(conf.pis, 'zz') && ~isempty(conf.pis(s).xx) && ~isempty(conf.pis(s).yy) && ~isempty(conf.pis(s).zz)
                fprintf(fid,' \nconf.pis(%d).inertia \t = [%1.6f, 0, 0; 0, %1.6f, 0; 0, 0, %1.6f ]; ',s,conf.pis(s).xx, conf.pis(s).yy, conf.pis(s).zz);
            end
        end
    end


    fprintf(fid,'\n \n %% Rototranslation matrix \n');
    GL = nan(size(GL_tp));
    for i = 1:size(GL,3) 
        if i == 1
            GL(:,:,i) = eye(4);
        else
            GL(:,:,i) = invR(GL_tp(:,:,conf.S(i).parent)) * GL_tp(:,:,i); % Trouver le RT local de chaque segment
        end
    end
       
    
    TAGSm=squeeze(nanmean(TAGS,3)); %position moyenne des marqueurs dans les reperes locaux

    for s=1:conf.segments 
        fprintf(fid,'conf.pis(%d).RT\t= [[',s);
        for i = 1:3
            fprintf(fid,'%1.10f, %1.10f, %1.10f;',GL(i,1:3,s));
        end
        fprintf(fid, '0 0 0]\t[%1.10f; %1.10f; %1.10f; 1]];', GL(1:3,4,s));
        fprintf(fid, '\t %%%s\n', conf.S(s).name);
    end

    fprintf(fid,' \n \n%% Tags refer picture \n');
    fprintf(fid, 'conf.T = [\n');

    count=0;
    for s=1:conf.segments
        for k=1:conf.S(s).nreal
            count=count+1;
            fprintf(fid,'\t%1.10f,%1.10f,%1.10f; ... %% %s\n',TAGSm(1,k,s),TAGSm(2,k,s),TAGSm(3,k,s), conf.MarkName{count});
        end%for k
    end%for s
    fprintf(fid, '];');

    status=fclose(fid); 
    if ~status
        fprintf(     '\nLe fichier %s a ete genere avec succes !!\n',name); 
        if isfield(conf, 'rid') && ~isempty(conf.rid)
            fprintf(conf.rid, '\nLe fichier %s a ete genere avec succes !!\n',name); 
        end
    end

    % Générer le fichier final
    generateS2MModel(conf);


end