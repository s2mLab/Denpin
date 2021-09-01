function [M, instants] = LoadViconFile(s,conf, ~, mark) % ~ est une variable inutile qui justifin la ligne 13

    % Load des données
    if isnumeric(s)
        FileName=[conf.file.root int2str(s) conf.file.ext];
    else
        FileName=[conf.file.root '/' s conf.file.ext];
    end
    fprintf(     '\nLoading file %d (%s)\n',s, FileName);
    if ~isempty(conf.rid)
		fprintf(conf.rid, '\nLoading file %d (%s)\n',s, FileName);
    end
    newData = OrgData(FileName,conf);  
    
    if nargin >= 4
        [M, instants]=table2class(newData/1000,mark); 
    elseif nargin==3
        [M, instants]=table2class(newData/1000     );
    else
        % Reclassement
        mark = conf.num(1,1):conf.num(end,2);
        mark = [mark*3-2; mark*3-1; mark*3]; mark=mark(:)'; 
        [M, instants] = table2class(newData/1000,mark); 
    end
    
end