function M = LoadFunctionalData(conf, s, r)
    % s => numéro du segment actuel

    % Ouvrir le fichier
    str_s = int2str(s);
    FileName = [conf.file.root 'func' str_s conf.file.ext];
    newData = OrgData(FileName,conf);

    
   
    % Choix des markers techniques uniquement
    mark = [conf.num(r,1):conf.num(r,3) conf.num(s,1):conf.num(s,3)]; % Tous les markers techniques
    MarkName = ''; 
    for i=1:length(mark)
        MarkName= [MarkName char(conf.MarkName(mark(i))) ' '];  %#ok<AGROW>
    end
    fprintf(     'Marqueurs utilises: %s\n', MarkName);    
    fprintf(conf.rid, 'Marqueurs utilises: %s\n', MarkName);
    
    % Classer les données
    mark = [mark*3-2; mark*3-1; mark*3]; mark=mark(:)'; 
    M =table2class(newData,mark)/1000; %enleve les lignes avec des marqueurs absents

end