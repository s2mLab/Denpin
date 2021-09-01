function [R_t0, MS] = getLocalSegment(conf, Mstat)



    % Déclaration de variables
    nb0=[conf.S(1:conf.segments).n];
    nb = nb0; 
    MS=nan(4,max(nb+4),size(Mstat,3),conf.segments);%Matrice 4D (XYZ,marqueurs,temps,segments)
    MS(4,:,:,:) = 1;
    max_n=0; 
    for s=1:conf.segments, 
        max_n = max([max_n conf.S(s).n]); 
    end
    Group = zeros(conf.segments, max_n+3);
    R_t0 = nan(3,3,conf.segments);


    for s=1:conf.segments
        % variables temporaires
        a = conf.num(s,1);%first marker
        b = conf.num(s,2);%last marker
        c = conf.num(s,3); % last technical marker
        d = b-a+1; % total # markers
        e = c-a+1; % total # technical markers

        tp1 = Mstat(:,a:c,:);
        tp2=FourGroups(mean(tp1(:,:,1),3));  %determiner 2 vecteurs le plus perpendiculaire l'un a l'autre        
        if sum(tp2) ~= 0 % Si on a suffisamment de marqueurs
            tp3=Use4Groups(mean(tp1(:,:,1),3),tp2);   
        elseif size(tp1,2) == 2 % Si on a deux marqueurs pour le segment
            tp3 = averageRT(defineAxis(tp1(:,2,:)-tp1(:,1,:),repmat([1 0 0 0]',[1 1 size(tp1,3)]), 'xy', 'x', zeros(3,1,size(tp1,3)))); 
            tp3 = tp3(1:3,1:3);
        end


        % stockage
        MS(1:3,1:d,:,s)=Mstat(:,a:b,:);
        if e==3, Group(s,1:e+4) = tp2; 
        else     Group(s,1:e+3) = tp2; end
        conf.S(s).group = tp2;

        R_t0(:,:,s) = tp3; 


        fprintf(          'segment %d %s ... %d markers, from %d to %d\n',s,conf.S(s).name,c,a,b);
        if isfield('rid', 'conf')
            fprintf(conf.rid, 'segment %d %s ... %d markers, from %d to %d\n',s,conf.S(s).name,c,a,b);
        end

        if isfield(conf, 'opt') && conf.opt.plot_auto
            Mmean = mean(Mstat(:,a:b,:),3);
            figure(conf.h.f1);     plot3(Mmean(1,:),Mmean(2,:), Mmean(3,:),'.', 'color', conf.colo(s));
                            text (Mmean(1,:),Mmean(2,:), Mmean(3,:), int2str([1:conf.S(s).n]'))
        end
    end

end