function r = updateQInit(r, k, Q)

    if k < size(r.qinit,2)
        cmp = k;
        while cmp > 1 && nansum(Q(:,cmp)) == 0 % Il n'y a que des nan
            cmp = cmp-1;
        end
        tp = r.qinit(:,k+1);
        r.qinit(r.qutilises,k+1) = Q(r.qutilises,cmp); 
        r.qinit(isnan(r.qinit(:,k+1)),k+1) = tp(isnan(r.qinit(:,k+1))); % Ne pas transférer les nan
    end

end