function [CoR, t1,t2,t3, V, residual, CoR_M1, CoR_M2, residual0, new_q] = SCoRE(conf, RT1, M1, RT2, M2, first)

	% Determination du centre articulaire
	% Organisation en 3D : coordonnees, marqueurs, temps.
	% t1 centre dans le segment 1
    % t2 centre dans le segment 2
    % t3 Moyenne des centre
	q=1:size(RT1,3);	
        
    if nargin == 5 
        first = true;
    end
    
    A = nan(3*size(RT1,3),6);	
    b = nan(3*size(RT1,3),1);
    for i=q
	    A(i*3-2:i*3,:)=[RT2(1:3,1:3,i),-RT1(1:3,1:3,i)];
	    b(i*3-2:i*3,:)= RT1(1:3,  4,i)-RT2( 1:3,  4,i);
    end
    
   
    [U,S,V] = svd(A(~isnan(A(:,1)),:),0); 
    dS=diag(S);
    fprintf(     'singular value from %2.1f to %2.1f\n',dS(1), dS(3));
    if isfield(conf, 'rid') && ~isempty(conf.rid)
		fprintf(conf.rid, 'singular value from %2.1f to %2.1f\n',dS(1), dS(3));
    end

    
    CoR = V*diag(1./dS)*U'*b(~isnan(b));   
      
    t1 = multiprod(RT1, [CoR(4:6);1]);
    t2 = multiprod(RT2, [CoR(1:3);1]);
    residual = squeeze(sqrt(sum((t1-t2).^2)));
    
%     val = 1.0; %1.5; 
    
    if first
        residual0 = residual; 
%         res_mean = mean(residual);
%         res_std = std(residual);
%         new_q =  residual < res_mean; %+ val*res_std;
        new_q = residual <  prctile(residual,95);
        fprintf(    'Nouvelle appel de SCoRE pour enlever les images avec un r�sidu > 95 percentile\n');
        if isfield(conf, 'rid') && ~isempty(conf.rid)
            fprintf(conf.rid,'Nouvelle appel de SCoRE pour enlever les images avec un r�sidu > 95 percentile\n');
        end
        
        [CoR, t1,t2,t3, V, residual, CoR_M1, CoR_M2] = SCoRE(conf, RT1(:,:,new_q), M1(:,:,new_q), RT2(:,:,new_q), M2(:,:,new_q),false);
    else
        t3 = 0.5*(t1+t2);
        CoR_M1 = squeeze(sqrt(sum((M1(1:3,:,:) - repmat(t3(1:3)', [1,size(M1,2), size(M1,3)])).^2,1)))'; 
        CoR_M2 = squeeze(sqrt(sum((M2(1:3,:,:) - repmat(t3(1:3)', [1,size(M2,2), size(M2,3)])).^2,1)))'; 
    end
    

    
    