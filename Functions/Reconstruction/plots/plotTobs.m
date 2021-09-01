function h = plotTobs(r, h, Tobs, removeAxes)
    if nargin < 4
        removeAxes = false;
    end

    if r.showRecons && sum(nansum(Tobs)) ~= 0
        Tshow = Tobs(:,1:h.nT);
        Tshow(Tshow == 0) = nan;
        if removeAxes
            set(h.h21,'xdata', Tshow(1,:),'ydata', Tshow(2,:),'zdata', Tshow(3,:));
        else
            set(h.h2,'xdata', Tshow(1,:),'ydata', Tshow(2,:),'zdata', Tshow(3,:));
        end
        for ih1 = 1:length(h.h2t) 
            if removeAxes
                set(h.h21t(ih1),'position', Tshow(:,ih1));
            else
                set(h.h2t(ih1),'position', Tshow(:,ih1));
            end
        end
        h.showReconsk = true;  % Afficher les trucs à cet instant
        
    else
        h.showReconsk = false; % Afficher les trucs à cet instant
    end
    
end