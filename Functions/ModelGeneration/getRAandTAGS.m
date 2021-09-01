function [RA, TAGS] = getRAandTAGS(conf, MS, s, RA, TAGS)
    % Calcul le Repere anato du segment + les TAGS dans le local
    
   
    
    fprintf(     'Reperes et tags pour segment %s\n', conf.S(s).name);
    if isfield('rid', 'conf')
        fprintf(conf.rid, 'Reperes et tags pour segment %s\n', conf.S(s).name);
    end
    
    a=conf.S(s).U; 
    b=conf.S(s).V; 
    
    Mark_a=''; 
    for i=1:length(a)
        Mark_a= [Mark_a char(conf.S(s).MarkName(abs(a(i)))) ' '];  %#ok<AGROW>
    end   
    Mark_b=''; 
    for i=1:length(b)
        Mark_b= [Mark_b char(conf.S(s).MarkName(abs(b(i)))) ' '];  %#ok<AGROW>
    end   
    
    fprintf(     '\t u a partir de %s:%s\n', int2str(a),Mark_a);
    fprintf(     '\t v a partir de %s:%s\n', int2str(b),Mark_b);
    if isfield('rid', 'conf')
        fprintf(conf.rid, '\t u a partir de %s:%s\n', int2str(a),Mark_a);
        fprintf(conf.rid, '\t v a partir de %s:%s\n', int2str(b),Mark_b);
    end
    
    if isempty(a) % Si on utilise l'axe en copie d'un segment précédent
        if isfield(conf.S(s), 'UfromOtherSeg') && ~isempty(conf.S(s).UfromOtherSeg)
            U = [RA(1:3,conf.S(s).UfromOtherSeg(1),:,conf.S(s).UfromOtherSeg(2)); zeros([1,1,size(RA,3)])];
        elseif isfield(conf.S(s), 'UfromProjection') && ~isempty(conf.S(s).UfromProjection)
            P = mean(MS(1:3,conf.S(s).UfromProjection{1,1},:,conf.S(s).UfromProjection{1,2}),2);
            A = RA(1:3,4,:,conf.S(s).UfromProjection{2,2});
            B = A + RA(1:3,conf.S(s).UfromProjection{2,1}, :, conf.S(s).UfromProjection{2,2});
            P2 = projectPointOnLine(P,A,B);
            U = [P2-P; zeros([1,1,size(RA,3)])];
        elseif isfield(conf.S(s), 'UFootFromLineProjectionForGauthier' ) && ~isempty(conf.S(s).UFootFromLineProjectionForGauthier)
            P = MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{1,1},:,conf.S(s).UFootFromLineProjectionForGauthier{1,2}) ...
                - MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{1,3},:,conf.S(s).UFootFromLineProjectionForGauthier{1,4}) ;
            
            N = cross(MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{2,1},:,conf.S(s).UFootFromLineProjectionForGauthier{2,2}) ...
                - MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{2,3},:,conf.S(s).UFootFromLineProjectionForGauthier{2,4}), ...
                MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{3,1},:,conf.S(s).UFootFromLineProjectionForGauthier{3,2}) ...
                - MS(1:3,conf.S(s).UFootFromLineProjectionForGauthier{3,3},:,conf.S(s).UFootFromLineProjectionForGauthier{3,4})) ;
            P = P./repmat(normVector(P), [3,1,1]);
            N = N./repmat(normVector(N), [3,1,1]);
            U = P-multiprod(multiprod(multitransp(N),P),N);%
            U = [U; zeros(1,1,size(U,3))];
        else
            U=RA(:,strfind('xyz',conf.S(s).xyz),:,s-1);
        end
    else
        U=zeros(4,1,size(MS,3)); 
        for i=1:length(a)
            U=U+sign(a(i))*MS(:,abs(a(i)),:,s);   
        end
    end
    
    if isempty(b)  % Si on utilise l'axe en copie d'un segment précédent
        if isfield(conf.S(s), 'VfromOtherSeg') && ~isempty(conf.S(s).VfromOtherSeg)
            V = [RA(1:3,conf.S(s).VfromOtherSeg(1),:,conf.S(s).VfromOtherSeg(2)); zeros([1,1,size(RA,3)])];
        else
            w = strfind('xyz',conf.S(s).xyz)+1; if w==4; w=1; end
            V=RA(:,w,:,s-1);
        end
    else
        V=zeros(4,1,size(MS,3)); 
        for i=1:length(b)
            V=V+sign(b(i))*MS(:,abs(b(i)),:,s);  
        end
    end
    
  
    
    % Si aucun origine d�cid� et que le segment et son parent sont des axes, prendre la plus petite distance entre les deux axes comme CoR
    if isempty(conf.S(s).O) && strcmp(conf.S(s).Joint,'aor') && strcmp(conf.S(s-1).Joint,'aor') 
        keyboard
    else
        O=mean(MS(:,conf.S(s).O,:,s),2);
    end
    

    RA(:,:,:,s)=Rep_Loc2([O U V],conf.S(s).keep,conf.S(s).xyz);
      
    if isfield(conf, 'opt') && isfield(conf.opt, 'plot_auto') && conf.opt.plot_auto, figure(conf.h.f1); plotRef(RA(:,:,:,s),1); end%pause
	
	%% position des marqueurs dans le repere local
    for k=1:size(MS,3)
        R0A= invR(squeeze(RA(:,:,k,s)));
        for j=1:size(MS,2)
            if ~isnan(sum(MS(1:3,j,k,s)))
                TAGS(:,j,k,s)=R0A*MS(:,j,k,s);
            end
        end
    end

end