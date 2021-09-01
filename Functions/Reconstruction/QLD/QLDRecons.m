function [Q,DIFF] = QLDRecons(r)
% IN:
    % r.TOBS => markers observés
    % r.mark => matrice de markers utilisés
    % r.MarkW => Poids de chaque marker
    % r.qutilises => DoF à utiliser
    % r.qinit => matrice de solutions initiales
    % r.UseEllips => true s'il y a une ellipsoide
    % r.def => someDefinitions
% OUT:
    % Q => Reconstrutions
    % DIFF => Erreur de recons

    % Loader le modèle 
    r.model = biorbd('new', r.modelPath);

    % Initialiser les plots
    hplots = InitPlots(r);

    % D�terminer le nombre de marqueurs (NTAG)
    NTAG = getNTags(r);

    % valeurs générales
    [~,n_Tobs,n_frames] = size(r.TOBS);
    r.MARK = (1:n_Tobs)';	

    % Poids pendant la reconstruction
    W0 = getW0(r);

    % Initiation des variables de sortie
    Q = nan(length(r.qutilises), n_frames);
    DIFF = nan(NTAG*3,n_frames);

    % Option d'optimisation
    options = optimset('lsqnonlin');
    options.Jacobian = 'on';
    options.Display = 'off';
    options.TolFun = 1e-10;
    options.TolX = 1e-10;
    options.DerivativeCheck = 'off';
    options.Algorithm = 'levenberg-marquardt';
%     options.Algorithm = 'trust-region-reflective';
    
    % Reconstruction
    first = true;
    for k=1:n_frames
        if r.showRecons == 3 && k ~=1
            r.showRecons = 1;
        end
        
        % Affichage des marqueurs observ�s
        hplots = plotTobs(r, hplots,r.TOBS(:,:,k));

        % Choix des marqueurs présents et ajustement de Tutilises
        [Tobs, Tutilises, TutilisesJ] = getTobsK(r, k, NTAG);

        % Trouver le qinit
        q = getQInit(r,k);

        % Ajuster les pondérations
        W = getWk(W0, Tutilises, NTAG);

        % Lancer l'optimisation pour l'instant k
        if ~isempty(Tobs)
            if first % Si on est au premier frame, place le root en premier
                Tlocal = biorbd('segmentsmarkers', r.model, zeros(biorbd('nq', r.model),1));
                nbTagOnRoot = size(Tlocal{1},2);
                r2 = r;
                r2.mark(nbTagOnRoot+1:end,:) = false;
                [Tobs, Tutilises, TutilisesJ, Tutilises3] = getTobsK(r2, k, NTAG);
                % Ajuster les pondérations
                W = getWk(W0, Tutilises, NTAG);
                q = lsqnonlin(@(x)obj(x, r2, k, W, Tobs, Tutilises, TutilisesJ, hplots),q,r.lb,r.ub,options);
                [Tobs, Tutilises, TutilisesJ, Tutilises3] = getTobsK(r, k, NTAG);
                W = getWk(W0, Tutilises, NTAG);
                first = false;
            end
            
            xopt = lsqnonlin(@(x)obj(x, r, k, W, Tobs, Tutilises, TutilisesJ, hplots),q,r.lb,r.ub,options);
            qrec = setQRec(xopt, r,k);
        else
            qrec = setQRec(nan(size(q)),r,k);
        end
        % Sauvegarde dans la matrice de sortie
        Q(:,k) = qrec;

        % Plot des positions
        plotTcalc(hplots, r, qrec);
        if r.UseRemoveAxes
            hplots = plotTobs(r, hplots,biorbd('projectpoint', r.model, qrec, Tobs), true);
        end
        
        % Calcul de l'effeur de reconstruction
        DIFF([Tutilises Tutilises+NTAG Tutilises+2*NTAG],k) = W*calcDiff(qrec,r,Tutilises, Tobs, hplots);

        % Passer la position actuelle comme position initiale lors de l'itération suivante
        r = updateQInit(r, k, Q);

        % Refresh du graphique
        updatePlots(hplots);

        % Inscrire pour l'utilisateur o� on est rendu
        showAvancement(k);
    end

    fprintf('\n');


    % Fermer le model
    biorbd('delete', r.model);
    if isfield(hplots, 'record') && ~isempty(hplots.record)
        close(hplots.record);
    end
end


% Fonction objective de l'optimisation
function [F,J] = obj(x, r, k, W, Tobs, Tutilises, TutilisesJ, hplots)
    % Trouver la position des marqueurs actuels
    q = r.qinit(:,k); 
    q(r.qutilises) = x;
    
    % Calcul de l'erreur
    if r.showRecons == 2 || r.showRecons == 3
        F = W*calcDiff(q, r, Tutilises, Tobs, hplots);
    else
        F = W*calcDiff(q, r, Tutilises, Tobs);
    end
    
    % Afficher si on est dans ce cas spécial
    if r.showRecons == 2 || r.showRecons == 3
        if r.UseRemoveAxes
            hplots = plotTobs(r, hplots,biorbd('projectpoint', r.model, q, Tobs), true);
        end
        plotTcalc(hplots,r, q);
        updatePlots(hplots)
    end

    % Si la jacobienne est demand�e
    if nargout==2
        J = W*JacobianQ(r, q, TutilisesJ,hplots, Tobs);
    end
end
