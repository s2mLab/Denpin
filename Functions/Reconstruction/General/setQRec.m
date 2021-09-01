function qrec = setQRec(xopt, r,k)
    qrec = r.qinit(:,k);
    qrec(r.qutilises) = xopt;