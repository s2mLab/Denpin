function [Tobs, Tutilises, TutilisesJ, Tutilises3] = getTobsK(r, k, NTAG)


    markk=r.mark(:,k);  
    Tobs=r.TOBS(:,:,k); 
    Tobs(Tobs == 0) = nan;
    if r.UseEllips
        if ~isempty(Tobs)   
            Tobs = [Tobs zeros(3,size(r.def.EllipsMarker,1))]; % zeros car on calcule l'ellipsoide par rapport � zero
            Tutilises=[r.MARK(markk); (NTAG-size(r.def.EllipsMarker,1)+1:NTAG)'];  % + NTAG pour ellipsoide
        else
            Tutilises = r.MARK(markk); % Empty matrix: 0-by-1
        end
    else
        Tutilises=r.MARK(markk);
    end
    
    % Marqueurs utilis�s lors de la partie de la jacobienne correspondant aux Tags observes
    if r.UseEllips
        TutilisesJ = [Tutilises(1:end-size(r.def.EllipsMarker,1)); Tutilises(1:end-size(r.def.EllipsMarker,1))+NTAG-size(r.def.EllipsMarker,1); Tutilises(1:end-size(r.def.EllipsMarker,1))+2*(NTAG-size(r.def.EllipsMarker,1))];
    else
        TutilisesJ = [Tutilises; Tutilises+NTAG; Tutilises+2*NTAG];
    end
    Tutilises3 = [Tutilises; Tutilises+NTAG; Tutilises+2*NTAG];
end