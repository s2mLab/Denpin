function J = JacobianQ(r,q,TutilisesJ,hplots, Treal)
    if nargin < 4
        hplots = [];
    end

    % Récupérer la jacobienne des tags
    J = biorbd('MarkersJacobian', r.model, q, false, r.UseRemoveAxes); 
    if r.UseRemoveAxes
        J2 = biorbd('projectpointJacobian', r.model, q, Treal);
        J = J-J2;
    end
        % % Retirer les doublons?
        % n = histc(r.DOFidx, unique(r.DOFidx));
        % for i=find(n>1)
        %     J(:,i)= sum(J(:,r.DOFidx==i),2);
        % end
    % Prendre que les valeurs utilisees
    J = J(TutilisesJ, r.qutilises);

    % Récupérer la jacobienne de l'ellipsoide
    if r.UseEllips && ~isempty(J) % Si J est empty c'est qu'aucune donnée n'est enregistrée..
        Jaco = numdiff(@CalculateEllipsoide,q,[],r,0,hplots);
        sizeJ1 = size(J,1);
        J = [J(1:sizeJ1/3,:); Jaco(1:size(r.def.EllipsMarker,1),r.qutilises);...
            J(sizeJ1/3+1:sizeJ1*2/3,:); Jaco(size(r.def.EllipsMarker,1)*2-size(r.def.EllipsMarker,1)+1:size(r.def.EllipsMarker,1)*2,r.qutilises); ...
            J(sizeJ1*2/3+1:end,:); Jaco(size(r.def.EllipsMarker,1)*3-size(r.def.EllipsMarker,1)+1:size(r.def.EllipsMarker,1)*3,r.qutilises)];
    elseif r.UseEllips && isempty(J) % Je ne suis pas sûr de la robustesse de ce elseif
        J = zeros(3,sum(r.qutilises));
        
    end
end