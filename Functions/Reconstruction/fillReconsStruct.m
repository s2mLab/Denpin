function recons = fillReconsStruct(recons, param, conf)
    % Note : param peut �tre = []
    % S'assurer que les parametres essentiels sont presents
    % Type d'algorithme de reconstruction
    if ~isfield(recons, 'reconsAlgo')
        error('No Algorithm has been chosen, please select either reconsAlgo = ''kalman'' or ''QLD''');
    end
    
    % Donnees
    if ~isfield(recons, 'TOBS') || isempty(recons.TOBS)
        error('No data were sent, TOBS must exist and not be empty');
    end
    
    
    
    % Rajouter les parametres optionnels
    % Path du model
    if ~isfield(recons, 'modelPath')
        recons.modelPath = [conf.path.libPath '/Model.s2mMod'];
    end
    
    % Qinit
    if ~isfield(recons, 'qinit')
        recons.qinit = [];
    end
    
    % Utilisation ou non de l'ellipsoide
    if ~isfield(recons, 'UseEllips')
        recons.UseEllips = false;
    end
    
    % Valeurs l'ellipsoide (vide si aucune)
    if ~isfield(recons, 'def') || ~isfield(recons.def, 'Ellipsoide')
        recons.def.Ellipsoide = [];
        recons.UseEllips = false;
    end
    
    % montrer la reconstruction
    if ~isfield(recons, 'showRecons')
        recons.showRecons = true;
    end
    
    % Enregistrer la reconstruction
    if ~isfield(recons, 'record')
        recons.record = false;
    end
    if recons.record && ~recons.showRecons
        error('It is not possible to record without showing!')
    end
   
    % Indice des marqueurs pond�r�s
    if ~isfield(recons, 'MarkW')
        recons.MarkW = [];
    end
    
    % Valeur de la pondération des marqueurs
    if ~isempty(param) && isfield(param, 'W')
        recons.W = param.W;
    else
        recons.W = 10;
    end
    
    if ~isempty(param) && isfield(param, 'WEllips')
        recons.WEllips = param.WEllips;
    else
        recons.WEllips = 10;
    end
    
    if ~isempty(param) && isfield(param, 'UseRemoveAxes')
        recons.UseRemoveAxes = param.UseRemoveAxes;
    else
        recons.UseRemoveAxes = false;
    end
    if ~isempty(param) && isfield(param, 'UseScapulaLocator') && param.UseScapulaLocator
        recons.scapulaLocatorModelPath = [conf.path.libPath '../ScapulaLocator/scapulaLocatorCalib.s2mMod'];
    end
    
 
end