function Tcalc = forwardKin(r,Tutilises,q,h)

    Tcalc = biorbd('markers', r.model, q, 'all', r.UseRemoveAxes)';
    
    
    % Prendre les T conservés uniquement
    if r.UseEllips
        Tcalc = Tcalc(Tutilises(1:end-size(r.def.EllipsMarker,1)), :); 
    else
        Tcalc = Tcalc(Tutilises, :); 
    end
    
    % Ajouter les T de l'ellipsoide
    if r.UseEllips
        if ~isempty(Tcalc)
            if r.showRecons > 0 && nargin >=4
                d2 = CalculateEllipsoide(q,r,2,h)';
            else
                d2 = CalculateEllipsoide(q,r)';
            end
            Tcalc = [Tcalc; d2]; 
        else % Je ne suis pas certain de la robustesse de ceci..
            Tcalc = [0 0 0];
        end
    end


end
