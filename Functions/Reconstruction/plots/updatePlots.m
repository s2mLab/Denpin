function updatePlots(h)

    if h.showReconsk 
        axis equal
        drawnow
        if ~isempty(h.record)
            writeVideo(h.record,getframe(h.fig));
        end
    end
    
    