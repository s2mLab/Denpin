function conf = setPaths(conf)
    % IN : 
    % conf.subject.pseudo (nom du sujet)
    % conf.lateralite ('' ou 'd')
    % conf.side ('left' ou 'right')
    % conf.model (# du model)
    % recursiveCMP ne devrait jamais être envoyé, c'est une variable interne
    
    
    conf.path.basePath = [pwd '/../Data'];
    
    % Ajouter les path nécessaires
    if isfield(conf, 'model')
        model = conf.model; % back-up car conf.model doit être changé
        conf.model = floor(model);

        % Loader le fichier de conf
        run(sprintf('%s/config/GENERIC/conf_common.m', conf.path.basePath));
        run(sprintf('%s/config/GENERIC/conf_model_%d.m', conf.path.basePath, conf.model));

        % Remettre le numero du model
        conf.model = model;

        % Parametres inertiels
        
        %munlock(sprintf('%s/confS2M.m', conf.path.libPath));
        clear('confS2M.m')
        run(sprintf('%s/confS2M.m', conf.path.libPath));
    end
end