function  W = getWk(W0, Tutilises, NTAG)
    W = W0([Tutilises; Tutilises+NTAG; Tutilises+2*NTAG], [Tutilises; Tutilises+NTAG; Tutilises+2*NTAG]);