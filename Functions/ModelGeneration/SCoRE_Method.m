function [conf, MS] = SCoRE_Method(conf, s, R_t0, MS)
    % s est le numero du segment actuel (enfant)
    fprintf(            'SCoRE for segment %d\n',s);
    fprintf(conf.rid,   'SCoRE for segment %d\n',s);
    
    r=conf.S(s).parent; % r est le numero du segment parent
    % Load des donnees
    M = LoadFunctionalData(conf,s,r);
    
    % Separation des donnees en deux matrices
    M1 = M(:,conf.num(r,1):conf.num(r,3),:); %segment prox (premier au dernier marqueur technique
    M2 = M(:,conf.num(s,1):conf.num(s,3),:); %segment dist (premier au dernier marqueur technique

    fprintf(            'Nombre images : %d\n', size(M1,3));
    fprintf(conf.rid,   'Nombre images : %d\n', size(M1,3));
    
	% reperes locaux optimises par rapport au statique MS (limiter soft tissue artefact)
    [RT1,Rd1, resid1] = Rep_Loc(M1,R_t0(:,:,r),mean(MS(1:3,1:conf.S(r).nT,:,r),3)); %axes unitaires par la fonction unit (r = segment parent =  proximal de l'articul.)
    [RT2,Rd2, resid2] = Rep_Loc(M2,R_t0(:,:,s),mean(MS(1:3,1:conf.S(s).nT,:,s),3)); % s=segment = distal de l'articul.)
   
    remove_auto=1;
    
    if remove_auto
        nbf = size(resid1,1);
        frames  =  all(resid1< ones(nbf,1)*(mean(resid1)+1.5*std(resid1)),2) & ....
                   all(resid2< ones(nbf,1)*(mean(resid2)+1.5*std(resid2)),2);  
               
        fprintf(            '%d frames sur %d ont ete conservees\n',sum(frames),nbf);
        fprintf(conf.rid,   '%d frames sur %d ont ete conservees\n',sum(frames),nbf);
               
    else frames = ones(1,size(M,3))==1;
    end
    
    
    %% SCoRE pour determiner le CoR
    [CoR, t1,t2,score, V, residual, CoR_M1, CoR_M2, residual0, kept_frames] = SCoRE(conf, RT1(:,:,frames),M1(:,1:conf.S(r).nT,frames),RT2(:,:,frames),M2(:,1:conf.S(s).nT,frames));
    AoR =  V(:,6);
    conf.S(s).CoR = CoR;
    conf.S(s).AoR = AoR; %cas d'un axe de rotation (ex coude) methode de O'Brien

    for j=1:conf.S(r).nT
        fprintf(            'distance CoR marker %d %s, segment proximal %3.1f (%3.1f) mm\n', j,char(conf.S(r).MarkName(j)), mean(CoR_M1(:,j))'*1000, std(CoR_M1(:,j))'*1000);
        fprintf(conf.rid,   'distance CoR marker %d %s, segment proximal %3.1f (%3.1f) mm\n', j,char(conf.S(r).MarkName(j)), mean(CoR_M1(:,j))'*1000, std(CoR_M1(:,j))'*1000);
    end

    for j=1:conf.S(s).nT
        fprintf(            'distance CoR marker %d %s, segment distal %3.1f (%3.1f) mm\n', j,char(conf.S(s).MarkName(j)), mean(CoR_M2(:,j))'*1000, std(CoR_M2(:,j))'*1000);
        fprintf(conf.rid,   'distance CoR marker %d %s, segment distal %3.1f (%3.1f) mm\n', j,char(conf.S(s).MarkName(j)), mean(CoR_M2(:,j))'*1000, std(CoR_M2(:,j))'*1000);
    end
    
     if conf.opt.plot_auto 
        figure_residualR(conf, r,s, resid1, resid2, frames); 
        figure_residualCoR(conf, r,s,residual0, residual);
        figure_CoR_setup(conf, r,s, M,M1,M2, RT1, RT2);     % Graphics: CoR dans l'essai
     end    
    
     
     
     %% dans le statique
    M1 = MS(1:3,1:conf.S(r).nT,:,r);
    M2 = MS(1:3,1:conf.S(s).nT,:,s);   
    
    [RT1,~]=Rep_Loc(M1,R_t0(:,:,r)); %axes unitaires par la fonction unit
    [RT2,~]=Rep_Loc(M2,R_t0(:,:,s));
    
    % replace les CoR, AoR dans la statique
    for i=1:size(MS,3)%i=image
        pp=1;
        if mod(i,10) == 0
            fprintf(     '%d...',i);
            fprintf(conf.rid, '%d...',i);
            if mod(i,100) == 0
                fprintf('\n');
                fprintf(conf.rid, '\n');
            end
        end
        t1 = RT1(:,:,i)*[CoR(4:6);1]; 
        t2 = RT2(:,:,i)*[CoR(1:3);1];
        score= 0.5*(t1+t2);
        
       if strcmp(conf.S(s).Joint,'aor')
%        if strcmp(conf.S(s).Joint,'cor')
            t4 = unit(RT1(:,:,i)*[AoR(4:6);0]);
            t5 = unit(RT2(:,:,i)*[AoR(1:3);0]);
            sara = 0.5*(t4+t5);  


            if ~isfield(conf.S(s), 'JointSpecialTreatment') && strcmpi(conf.S(s).name, 'LowerArm1')
                warning('please create a (conf.S(s).JointSpecialTreatment = ''elbow'') tag for the segment s=%d', s)
                conf.S(s).JointSpecialTreatment = 'elbow';
            end
            
            if ~isfield(conf.S(s), 'JointSpecialTreatment')
                conf.S(s).JointSpecialTreatment = '';
            end
            
            if strcmpi(conf.S(s).JointSpecialTreatment, 'elbow') % Si coude, astuce pour assurer que t6 est de gauche a droite
                disp('Treat special case: elbow')
%                 tp = MS(1:3,conf.S(r).Ax(2),i,r) - MS(1:3,conf.S(r).Ax(1),i,r); %axe des epicondyles dans R0
                tp = MS(1:3,conf.S(r).Ax(2),i,r) - MS(1:3,conf.S(r).Ax(1),i,r); %axe des epicondyles dans R0
                tp = unit(invR(RT1(:,:,i))*[tp;0]); %axe des epicondyles dans R1

                if tp(1:3)'*AoR(4:6) < 0 
                    sara=-sara; 
                    fprintf(     '\n!!axe du coude inverse !!\n'); 
                    fprintf(conf.rid, '\n!!axe du coude inverse !!\n'); 
                end

                ErrElbow(i) = acos( dot(tp(1:3), AoR(4:6)) / norm(tp(1:3))/norm(AoR(4:6))); %#ok<AGROW>
                
                % Projection du milieu des epicondyles sur l'axe de rotation. 
                B = mean(MS(1:3,conf.S(r).Ax,i,r),2);         
                A = score(1:3);        
                AB = B-A;
                u = unit(sara(1:3));
                ABu = AB'*u;
                B2 = A + u*ABu;
                score = [B2;1];
                
            elseif strncmpi(conf.S(s).name, 'LowerArm2',9) % Si Avant-Bras, astuce pour assurer que t6 est de de bas en haut
                disp('Treat special case: LowerArm2')
            
%                 tp = MS(1:3,conf.S(r).Ax(2),i,r) - MS(1:3,conf.S(r).Ax(1),i,r); %axe longitudinal du bras
%                 tp = unit(invR(RT1(:,:,i))*[tp;0]); %axe des epicondyles dans R1

%                 if tp(1:3)'*AoR(4:6) > 0 && strcmp(conf.side, 'left'), 
                if [0 0 1]*sara(1:3) < 0 %&& strcmp(conf.side, 'left'), 
                    sara=-sara; 
                    fprintf(          '\n!!axe de l''avant-bras inverse !!\n'); 
                    fprintf(conf.rid, '\n!!axe de l''avant-bras inverse !!\n'); 
                end                
                
                
                % Le CoR sera place a� la projection de l'axe de parent et enfant
                long = .1; %0.05;
                u = unit(sara(1:3));
                
                %QUESTION: pourquoi utiliser la moyenne?
                A = [-mean(MS(1:3,conf.S(r).n  ,:,r),3), mean(MS(1:3,conf.S(r).n  ,:,r),3)]*long + ...
                    [ mean(MS(1:3,conf.S(r).n-1,:,r),3), mean(MS(1:3,conf.S(r).n-1,:,r),3)]; % [-t3 t3] + [u u] du segment precedent
                B = [-u, u]*long + [score(1:3) score(1:3)];
                ts = [A(:,2) - A(:,1),-(B(:,2)-B(:,1))]\(B(:,1) - A(:,1));
                score = [B(:,1) + (B(:,2) - B(:,1))*ts(2);1];
                
                
            elseif strcmpi(conf.S(s).JointSpecialTreatment, 'knee') % Si coude, astuce pour assurer que t6 est de gauche a droite
                 tp = MS(1:3,conf.S(s).Ax(2),i,r) - MS(1:3,conf.S(s).Ax(1),i,r); %axe des condyles dans R0
                %tp = MS(1:3,conf.S(s).Ax(1),i,s) - MS(1:3,conf.S(s).Ax(2),i,s); %axe des condyles dans R0
                tp = unit(invR(RT1(:,:,i))*[tp;0]); %axe des epicondyles dans R1

                if tp(1:3)'*AoR(4:6) < 0 
                    sara=-sara; 
                    fprintf(     '\n!!axe du genou inverse !!\n'); 
                    fprintf(conf.rid, '\n!!axe du genou inverse !!\n'); 
                end

                ErrElbow(i) = acos( dot(tp(1:3), AoR(4:6)) / norm(tp(1:3))/norm(AoR(4:6))); %#ok<AGROW>
                
                % Projection du milieu des epicondyles sur l'axe de rotation. 
                B = mean(MS(1:3,conf.S(s).Ax,i,s),2);         
				A = score(1:3);        
				AB = B-A;
				u = unit(sara(1:3));
				ABu = AB'*u;
				B2 = A + u*ABu;
				score = [B2;1];

			else
				warning('No correction on axis direction was done!');
				B = mean(MS(1:3,conf.S(s).Ax,i,s),2);         
				A = score(1:3);        
				AB = B-A;
				u = unit(sara(1:3));
				ABu = AB'*u;
				B2 = A + u*ABu;
				score = [B2;1];
			
            end
		
        end%if JointType
        
        MS(:,conf.S(r).n+pp,i,r)=score; % store CoR in static
        MS(:,conf.S(s).n+pp,i,s)=score; 

		

        
        % stockage des centres articulaires
        if strcmp(conf.S(s).Joint,'aor')
            pp=2;
            MS(:,conf.S(r).n+pp,i,r)=[u;0];
            MS(:,conf.S(s).n+pp,i,s)=[u;0];%verifier
			
			AoR_Name = sprintf('AoR_%s_%s',conf.S(r).name, conf.S(s).name);
			conf.S(r).MarkName = [conf.S(r).MarkName, AoR_Name];
			conf.S(s).MarkName = [conf.S(s).MarkName, AoR_Name];			
        end
        

        
        if i==1
            CoR_Name = sprintf('CoR_%s_%s',conf.S(r).name, conf.S(s).name);
            conf.S(r).MarkName = [conf.S(r).MarkName, CoR_Name];
            conf.S(s).MarkName = [conf.S(s).MarkName, CoR_Name];
            
            fprintf(     '\tCoR/AoR dans proximal a colonne %d\n',conf.S(r).n+pp);
            fprintf(conf.rid, '\tCoR/AoR dans proximal a colonne %d\n',conf.S(r).n+pp);
            
            fprintf(     '\tCoR/AoR dans distal   a colonne %d\n',conf.S(s).n+pp);
            fprintf(conf.rid, '\tCoR/AoR dans distal   a colonne %d\n',conf.S(s).n+pp);
 
            if conf.opt.plot_auto
                figure(conf.h.f1)
                hold on
                plot3(t1(1),t1(2),t1(3), 'ro-');
                plot3(t2(1),t2(2),t2(3), 'gs-');
                plot3(score(1),score(2),score(3), 'b*'); 
                if strcmp(conf.S(s).Joint,'aor')
                    t7=u*0.05; 
                    plot3([t7(1), -t7(1)]+score(1),...
                          [t7(2), -t7(2)]+score(2),...
                          [t7(3), -t7(3)]+score(3),'r-');
                end%if JointType
            end
        end
        
        
    end%for i
    
    % Augmenter le nombre de markers
    conf.S(r).n = conf.S(r).n+pp; 
    conf.S(s).n = conf.S(s).n+pp; 
    
    fprintf(            '\n\t %s passe de %d a %d marqueurs\n',    conf.S(r).name, conf.S(r).n-pp, conf.S(r).n);
    fprintf(conf.rid,   '\n\t %s passe de %d a %d marqueurs\n',    conf.S(r).name, conf.S(r).n-pp, conf.S(r).n);
    fprintf(            '  \t %s passe de %d a %d marqueurs\n\n\n',conf.S(s).name, conf.S(s).n-pp, conf.S(s).n);
    fprintf(conf.rid,   '  \t %s passe de %d a %d marqueurs\n\n\n',conf.S(s).name, conf.S(s).n-pp, conf.S(s).n);
         
    if exist('ErrElbow', 'var')
        fprintf(    'Erreur axe du coude (epicondyles versus axe optimal): %3.0f (%3.0f) deg\n', rad2deg(mean(ErrElbow)), rad2deg(std(ErrElbow)));
        fprintf(conf.rid,'Erreur axe du coude (epicondyles versus axe optimal): %3.0f (%3.0f) deg\n', rad2deg(mean(ErrElbow)), rad2deg(std(ErrElbow)));
    end
end
