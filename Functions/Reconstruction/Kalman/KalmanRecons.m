function [Q2,DIFF, V2, A2] = KalmanRecons(r)
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
    [W0, w0] = getW0(r);

% Initialisation du filtre de kalman
Te = 1/(r.def.frequence); 
[A,~,Q,R,xp, Pp] = 	InitializeKalman(r.qutilises,Te, r.def.Tq, r.def.Rq, w0);





% Initiation des variables de sortie
Q2 = nan(length(r.qutilises), n_frames);
V2 = Q2;
A2 = Q2;
DIFF = nan(1,n_frames);
% Reconstruction
K = findFirstFrame(r):size(r.TOBS,3); 
for k=K
    % Affichage des marqueurs observés
    hplots = plotTobs(r, hplots,r.TOBS(:,:,k));
    
    % Choix des marqueurs présents et ajustement de Tutilises
    [Tobs, Tutilises, TutilisesJ, Tutilises3] = getTobsK(r, k, NTAG);
   
    % Lancer l'optimisation pour l'instant k
    if k==K(1)
        if ~isfield(r, 'useQLDToInit') || ~r.useQLDToInit
            qinit2 = r.qinit(:,k); %QLDRecons(r_tp);
            Tlocal = biorbd('segmentsmarkers', r.model, zeros(biorbd('nq', r.model),1));
                
            for irep = 1:biorbd('nbody', r.model) % Faire l'initiation 2 fois (une fois le bassin, une fois le reste
                nMarkersNow = 0;
                for itp = 1:irep
                    nMarkersNow = nMarkersNow + size(Tlocal{itp},2);
                end
                r2 = r;
                r2.mark(setdiff(1:NTAG, 1:nMarkersNow),:) = false;
                [Tobs, Tutilises, TutilisesJ, Tutilises3] = getTobsK(r2, k, NTAG);
                for rr=1:10 %      if error on qinti1 ... will avoid initial oscillations
                    [xp,qinit2,~] = KalmanReconstruction(r, A,Tobs,Pp,xp,Q,R,Tutilises,Tutilises3,TutilisesJ,qinit2, W0);
                    xp(end/3+1:end) = 0; % Retirer les vitesse et l'accélération
                    % Ne pas conserver la matrice d'évolution

                    % Plot des positions
                    plotTcalc(hplots, r, qinit2);
                    % Refresh du graphique
                    updatePlots(hplots);
                end
            end
        else
            r2 = r;
            r2.TOBS = r.TOBS(:,:,1:K(1));
            r2.showRecons = false;
            qinit2 = QLDRecons(r2);
            qinit2 = qinit2(:,end);
            xp(1:end/3) = qinit2(r.qutilises);
        end
    else
        
        [xp,qinit2,Pp] = KalmanReconstruction(r, A,Tobs,Pp,xp,Q,R,Tutilises,Tutilises3,TutilisesJ,qinit2,W0);
    end
    
    % Set du qrec
    qrec = qinit2;
    qrec(r.qutilises) = xp(1:length(xp)/3);

    % Sauvegarde dans la matrice de sortie
    Q2(:,k) = qrec;
    V2(r.qutilises,k) = xp(length(xp)/3+1:length(xp)*2/3);
    A2(r.qutilises,k) = xp(length(xp)*2/3+1:length(xp));
    
    % Plot des positions
    plotTcalc(hplots, r, qrec);
    
    % Calcul de l'effeur de reconstruction
    DIFF(k) = norm(calcDiff(qrec, r, Tutilises, Tobs));%,hplots));

    % Passer la position déjà enregistrer aux q non utilisés à l'itération suivante
    if k < size(r.qinit,2)
        qinit2(~r.qutilises) = r.qinit(~r.qutilises, k+1);
    end
        
    % Refresh du graphique
    updatePlots(hplots);

    % Inscrire pour l'utilisateur o� on est rendu
    showAvancement(k);
end

V2(isnan(V2)) = 0;
A2(isnan(A2)) = 0;
fprintf('\n');

% Fermer le modèle
biorbd('delete', r.model);

end
