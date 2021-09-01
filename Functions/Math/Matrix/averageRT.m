function RTmean = averageRT(RT)
%     persistent coucou
%     if sum(size(coucou))>0
%         coucou = coucou+1;
%     else
%         coucou = 1;
%     end
%     
%     disp(coucou)
%     
%     if coucou == 13
%         disp('stop')
%     end
    % Procï¿½dure d'optimisation pour moyenner les RT
    seq = 'xyz';
    
    % Retirer les éventuels nan de RT
    RT = RT(:,:,~isnan(RT(1,1,:)));

    % Mettre en angles
    A = fromMatrixToAngle(RT, seq);
    if size(RT,2) == 4
        x0 = [mean(A,2); mean(RT(1:3,4,:),3)]; % solution initiale, la moyenne des angles
        useRT = true;
    else
        x0 = mean(A,2); % solution initiale, la moyenne des angles
        useRT = false;
    end

    % Optimiser
    opt = optimoptions('lsqnonlin', 'display', 'off');
    anglesMean = lsqnonlin(@obj, x0, [], [], opt);

    RTmean = createRT(anglesMean, seq, useRT);

    % Fonction ï¿½ optimiser (moyenne)
    function err = obj(x)
        % Convertir en matrice de rotation
        rt = createRT(x,seq, useRT);
        rt = repmat(rt, [1,1,size(RT,3)]);
        % Calcul de l'erreur
        err = rt - RT;

        err = err(:);
    end
    

end


function rt = createRT(x, seq, useRT)
    if useRT
        rt = eye(4);
        rt(1:3,1:3) = fromAngleToMatrix(x(1:3), seq);
        rt(1:3,4) = x(4:6);
    else
        rt = eye(3);
        rt(1:3,1:3) = fromAngleToMatrix(x(1:3), seq);
    end
end

