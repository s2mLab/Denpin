function Diff = calcDiff(q, r, Tutilises, Tobs,h)
    
    if nargin < 5
        Tcalc = forwardKin(r,Tutilises,q);
    else
        Tcalc = forwardKin(r,Tutilises,q,h);
    end
    if r.UseRemoveAxes && r.UseEllips
        Tobs2 = S2M_rbdl('projectpoint', r.model, q, Tobs(:,1:end-size(r.def.EllipsMarker,1)));

        % Calculer la différence avec les T observés
        Diff = Tcalc - [Tobs2(:,Tutilises(Tutilises<=size(Tobs2,2)),:) zeros(3,size(r.def.EllipsMarker,1))]';
    else
        if r.UseRemoveAxes
            Tobs2 = S2M_rbdl('projectpoint', r.model, q, Tobs);
        else
            Tobs2 = Tobs;
        end
        
        % Calculer la différence avec les T observés
        Diff = Tcalc - Tobs2(:,Tutilises)';
    end

    Diff = Diff(:);
end
