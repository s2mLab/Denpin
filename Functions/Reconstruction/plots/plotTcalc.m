function plotTcalc(h, r, q)

        % Affichage des positions marqueurs reconstruits
        if h.showReconsk
            T = biorbd('Markers', r.model, q, 'all', false);
        
            biorbd_ShowModel(r.model,q,h.h1);
            for ih = 1:length(h.h1t)
                set(h.h1t(ih),'position', T(:,ih));
            end
            
            if r.UseRemoveAxes
                T = biorbd('Markers', r.model, q, 'all', true);
        
                biorbd_ShowModel(r.model,q,h.h11);
                for ih = 1:length(h.h11t)
                    set(h.h11t(ih),'position', T(:,ih));
                end
            end
        end
    
end