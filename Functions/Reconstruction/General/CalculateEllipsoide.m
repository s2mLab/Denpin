    % Fonction du calcul de la distance entre un point et l'ellipsoide
    function pointFinal = CalculateEllipsoide(q,r,verb,h)
        T2 = S2M_rbdl('Tags', r.model, q, 'all', false)';
        for i = size(r.def.EllipsMarker,1):-1:1
            PScap = mean(T2(r.def.EllipsMarker(i,~isnan(r.def.EllipsMarker(i,:))),:),1)'; % Utile si useEllipseThorax
            GL=S2M_rbdl('globalJCS',r.model,q);
            GL = GL(:,:,2) * r.def.RTEllips;
            
            PScap_T = invR(GL) * [PScap;1];
            PScapF = (PScap_T(1:3)-r.def.Ellipsoide(1:3)')*1000; % Placer le point dans le repere Ellipsoide, *1000 pour robustesse
            point = DistancePointEllipsoid(PScapF(1), PScapF(2), PScapF(3), r.def.Ellipsoide(4)*1000, r.def.Ellipsoide(5)*1000, r.def.Ellipsoide(6)*1000);
            pointFinal(:,i) = (PScapF - point')/1000;
        end
        
        if nargin >= 4 && (r.showRecons == 2 || verb == 2)
            % Afficher l'ellipsoide
            [ell_p1, ell_p2, ell_p3] =ellipsoid(r.def.Ellipsoide(1), r.def.Ellipsoide(2), r.def.Ellipsoide(3), ...
                                                r.def.Ellipsoide(4), r.def.Ellipsoide(5), r.def.Ellipsoide(6));
            ps = [ell_p1(:)'; ell_p2(:)'; ell_p3(:)'; ones(1, length(ell_p1(:)))];
            ps = GL*ps;
            ell_p1 = reshape(ps(1,:), [sqrt(length(ps)) sqrt(length(ps))]);
            ell_p2 = reshape(ps(2,:), [sqrt(length(ps)) sqrt(length(ps))]);
            ell_p3 = reshape(ps(3,:), [sqrt(length(ps)) sqrt(length(ps))]);
            set(h.hell,'xdata', ell_p1, 'ydata', ell_p2, 'zdata', ell_p3);
        end
    end