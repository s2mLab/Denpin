function h = InitPlots(r)

    % r.showRecons sert � afficher la reconstruction. True = affiche, false = non, 2 = afficher chaque it�ration
    if r.showRecons
        h.nT = size(r.TOBS,2);
        h.fig = figure('Name','Global optimisation; red = real, black = model');
        hold on;
        xlabel('x'); 
        ylabel('y');
        zlabel('z');
%         h.h1 = plot3(nan,nan,nan,'k.');
        h.h1 = biorbd_ShowModel(r.model, 'tagsplotopt', {'linestyle', 'none'}, 'com', false, 'comi', false, 'useremoveaxes', false);
        h.h2 = plot3(nan,nan,nan,'ro');
        if r.UseRemoveAxes
            h.h11= S2M_rbdl_ShowModel(r.model, 'tagsplotopt', {'linestyle', 'none'}, 'com', false, 'comi', false, 'useremoveaxes', r.UseRemoveAxes);
            h.h21= plot3(nan,nan,nan,'go');     
        end
        if isfield(r, 'showReconsView')
            view(r.showReconsView);
        end
        for ih1 = 1:h.nT
            h.h1t(ih1)= text(nan,nan,nan, int2str(ih1)); 
            h.h2t(ih1)= text(nan,nan,nan, int2str(ih1), 'color', 'r'); 
            if r.UseRemoveAxes
                h.h11t(ih1)= text(nan,nan,nan, int2str(ih1)); 
                h.h21t(ih1)= text(nan,nan,nan, int2str(ih1), 'color', 'r');     
            end
        end
        if r.UseEllips
            [ell_p1, ell_p2, ell_p3] =ellipsoid(r.def.Ellipsoide(1), r.def.Ellipsoide(2), r.def.Ellipsoide(3), ...
                                                r.def.Ellipsoide(4), r.def.Ellipsoide(5), r.def.Ellipsoide(6));
            h.hell = surfl(nan(size(ell_p1)),nan(size(ell_p2)),nan(size(ell_p3)));
            set(h.hell, 'facealpha', 0);  
        end
        if isfield(r, 'recordReconsPath') && ~isempty(r.recordReconsPath) %% Si on enregistre la vidéo
            if ischar(r.recordReconsPath)
                if length(r.recordReconsPath)>=4 && strcmp(r.recordReconsPath(end-3:end), '.avi')
                    recPath = r.recordReconsPath;
                else
                    recPath = [r.recordReconsPath '.avi'];
                end
            else
                error('recordReconsPath should be a string');
            end
            axis off
            set(h.fig, 'color', 'w');
            
            h.record = VideoWriter(recPath);
            h.record.FrameRate = 10 ;
            open(h.record);
        else
            h.record = [];
        end
    else
         h = [];
    end

end