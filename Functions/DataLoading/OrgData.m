function [MM, t, c3d] = OrgData(FileName, confOrS2MModelPath, verbose)

if isstruct(confOrS2MModelPath)
    conf = confOrS2MModelPath;
elseif ischar(confOrS2MModelPath)
    m = S2M_rbdl('new', confOrS2MModelPath);
    conf.MarkName = S2M_rbdl('nameTags', m);
    S2M_rbdl('delete', m);
elseif isa(confOrS2MModelPath, 'uint64')
    conf.MarkName = S2M_rbdl('nameTags', confOrS2MModelPath);
elseif iscell(confOrS2MModelPath)
    conf.MarkName = confOrS2MModelPath;
end

if nargin <3
    verbose = true;
end

if strcmpi(FileName(end-3:end), '.c3d') && ~exist(FileName, 'file')
    if exist([FileName(1:end-4) '.csv'], 'file')
        warning('CSV is used instead of C3D, since no C3D file was found');
        FileName = [FileName(1:end-4) '.csv'];
    else
        error('No data found');
    end
end

%% read in conf
if strcmpi(FileName(end-3:end), '.csv')
    if ~isfield(conf, 'DELIMITER')
        conf.DELIMITER = ',';
    end
    delimit = conf.DELIMITER; 
    if ~isfield(conf, 'HEADERLINES')
        conf.HEADERLINES = [0 0; 5 2];
    elseif size(conf.HEADERLINES,1) == 1
        conf.HEADERLINES = [conf.HEADERLINES; conf.HEADERLINES; conf.HEADERLINES];
    end
    Ro = conf.HEADERLINES(:,1);
    Co = conf.HEADERLINES(:,2);
    MarkName = conf.MarkName;


    % keyboard
    fid = fopen(FileName);
    if fid==-1; 
                       fprintf(     '!!!!!!! Le fichier %s n''existe pas !!!!!!\n',FileName); 
                       keyboard
    end

    if ~isfield(conf, 'exp') || ~isfield(conf.exp, 'system')
        conf.exp.system = 'Nexus';
    end

    switch conf.exp.system 
        case 'Workstation'
            header = 10; % S�parateur donn� par les donn�es de WORKSTATION
            Ro = Ro(1);
            Co = Co(1);
        case 'Nexus'
            header = 3; % S�parateur donn� par les donn�es de NEXUS
            Ro = Ro(2);
            Co = Co(2);
        case 'Nexus2'
            header = 10; % S�parateur donn� par les donn�es de NEXUS
            Ro = Ro(3);
            Co = Co(3);
    end

    for i=1:header, 
        Head = fgetl(fid);  
    %     disp(Head)
    end


    MarkName2 = {};
    H = length(Head);
    h=1;

    while h<H
    % Sortir les noms des marqueurs de l'entete de la matrice sans le nom du
    % sujet (Mettre dans MarkName2)
        i=h; while Head(i)==',', if i==H; break; end; i=i+1; end
        j=i; while Head(j)~=',', if j==H; break; end; j=j+1; end
    %     MarkName2 = strvcat(MarkName2, Head(i:j-1));
        w = strfind(Head(i:j),':');
        if ~isempty(w), i=i+w; end
        if j==H && ~strcmp(Head(i:j), ','), MarkName2 = [MarkName2, Head(i:j)]; %#ok<AGROW>
        else     MarkName2 = [MarkName2, Head(i:j-1)];  %#ok<AGROW>
        end

        h=j;
    end
    if verbose
                       fprintf(     '\n');
    end


    fclose(fid);


    M_tp = dlmread(FileName,delimit,Ro,0);
    % fid = fopen(FileName);
    % M_tp = textscan(fid, '', 'delimiter', delimit, 'headerlines', Ro);
    % fclose(fid);
    M = nan(M_tp(end,1), size(M_tp,2)-Co);
    M(M_tp(:,1),:) = M_tp(:,Co+1:end);
    n = size(M,1);
    t = M_tp(:,1);

    MM = zeros(n,  length(MarkName)*3);

    for i=1:size(MarkName2,2)
        m  = M(:,i*3-2:i*3);
        name = char(MarkName2(1,i)); % Faire un nom � la fois

        mm = find(strcmp(MarkName, name)); % Comparer le nom avec celui o� il devrait �tre plac� et trouver o� il se trouve
        if isempty(mm), % Si le nom n'existe pas, il y a probablement une erreur dans le labelling
             if verbose
                                    fprintf(     '\n%s!!PB!!\n', name);
             end
        else 
    %         keyboard
            wh = m(:,1)~=0; 
            for j = 1:length(mm)
                MM(wh,mm(j)*3-2:mm(j)*3) = m(wh,:);  % Mettre le marqueur au bon endroit 
                if verbose
                                    fprintf(     '%s...ok;', name);
                end
            end


        end
    end
    if verbose
                        fprintf(     '\n\n');
    end   
elseif strcmpi(FileName(end-3:end), '.c3d')
    if exist('ezc3dRead', 'file')
        useEZC3D = true;
    else
        useEZC3D = false;
    end
    if useEZC3D
        c3d = ezc3dRead(FileName);
        M = c3d.data.points;
        MarkName2 = c3d.parameters.POINT.LABELS.DATA;
        
        if isfield(c3d.parameters, 'SUBJECTS') && isfield(c3d.parameters.SUBJECTS, 'LABEL_PREFIXES')
            prefixes = c3d.parameters.SUBJECTS.LABEL_PREFIXES.DATA;
            prefix_separator = ':';
            for i = 1:length(prefixes)
                prefixes{i} = prefixes{i}(1:end-1);
            end
        else
            prefixes = {};
        end
        
        firstFrame = c3d.header.points.firstFrame;
        lastFrame = c3d.header.points.lastFrame;
    else
        c = btkReadAcquisition(FileName);
        M = btkGetMarkers(c);
        MarkName2 = fieldnames(M);
        
        % Trouver le prefixe sur les noms de marqueurs s'il y en a un
        metadata = btkGetMetaData(c);
        
        try
            prefixes = metadata.children.SUBJECTS.children.NAMES.info.values;
            prefixes = strrep(prefixes, '-', '_');
            prefixes = strrep(prefixes, ' ', '_');
        catch
            prefixes = {};
        end
        prefix_separator = '_';
        firstFrame = btkGetFirstFrame(c);
        lastFrame = btkGetLastFrame(c);
    end
    t = firstFrame:lastFrame;
    
    MM = zeros(lastFrame-firstFrame+1,length(conf.MarkName)*3);
    for i = 1:length(MarkName2)
        name = char(MarkName2(i)); % Faire un nom � la fois
        for j=1:length(prefixes)
            if length(name)>length(prefixes{j}) && strcmp(name(1:length(prefixes{j})+1), [prefixes{j} prefix_separator])
                name = name(length(prefixes{j})+2:end);
                break;
            end
        end
        
        mm = find(strcmp(conf.MarkName, name)); % Comparer le nom avec celui o� il devrait �tre plac� et trouver o� il se trouve
        if isempty(mm) && verbose
            fprintf(     '%s...NOT USED;\n', name); 
        end
        
        
        for j = 1:length(mm)
            if useEZC3D
                MM(:,mm(j)*3-2:mm(j)*3) = squeeze(M(:,i,:))';
            else
                MM(:,mm(j)*3-2:mm(j)*3) = M.(MarkName2{i});  % Mettre le marqueur au bon endroit 
            end
            if verbose
                fprintf(     '%s...ok;\n', name);
            end
        end

    end
    if ~useEZC3D
        btkCloseAcquisition(c);
    end
    
else
    error('OrgData can open csv or c3d files only')
    
end
    
    
    
