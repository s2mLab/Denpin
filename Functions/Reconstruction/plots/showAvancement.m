function showAvancement(k)

    if ~mod(k,10) ; fprintf('%d..',k); end
    if ~mod(k,100); fprintf('\n'); end