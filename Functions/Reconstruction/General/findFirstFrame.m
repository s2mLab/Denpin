function w = findFirstFrame(r)

    % Trouver le premier frame sans nan
    if size(r.TOBS,3)>100 
        w = 1;
        while  sum(r.mark(~isnan(r.mark(:,w)),w))==0 %nansum(mark(:,w)) == 0
            w = w+1;
            if w>size(r.mark,2)
                break
            end
        end
    %     [~,w] = max(sum(mark(:,1:60),1)); 
    else
        w=1;
    end

end