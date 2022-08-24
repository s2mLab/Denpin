conf.dof=max(abs(conf.S(end).dof));%nb degres de liberte
conf.colo = 'rgbmcykrgbmcyk';


a=0;
for s=1:conf.segments
    b = a+conf.S(s).n; 
    c = a+conf.S(s).nT;
    conf.num(s,:) = [a+1 b c];
	conf.S(s).MarkName = conf.MarkName(a+1:b);
	conf.S(s).MarkIndex = [a+1:b];
    a=b;
end