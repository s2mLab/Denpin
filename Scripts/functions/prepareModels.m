function models = prepareModels(modelToUse, isScapula)
    models = [];
    
    % Prepare all possible models
    i = 1;
    models(i).source = 'skin markers';
    models(i).number = 1.0;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12];
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 2;
    models(i).source = 'skin markers';
    models(i).number = 1.1;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 3;
    models(i).source = 'skin markers';
    models(i).number = 1.2;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 4;
    models(i).source = 'skin markers';
    models(i).number = 1.3;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 5;
    models(i).source = 'skin markers';
    models(i).number = 1.4;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 6;
    models(i).source = 'skin markers';
    models(i).number = 1.5;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 7;
    models(i).source = 'skin markers';
    models(i).number = 1.6;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12};
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 8;
    models(i).source = 'pins markers';
    models(i).number = 2.0;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12}; 
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    i = 9;
    models(i).source = '? markers';
    models(i).number = 3.0;
    models(i).rotIdx = {4:6, 10:12};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 4:6;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [7:9 10:12]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12}; 
    models(i).GHrot = 10:12;
    models(i).folder = '';
    models(i).color = '';
    
    
    i = 10;
    models(i).source = 'skin markers';
    models(i).number = 101.1;
    models(i).rotIdx = {10:12, 16:18};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 10:12;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [13:15 16:18]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12}; 
    models(i).GHrot = 16:18;
    models(i).folder = '';
    models(i).color = '';
    
    i = 11;
    models(i).source = 'pins markers';
    models(i).number = 102.0;
    models(i).rotIdx = {10:12, 16:18};
    models(i).rotSeqIn = {'zyx', 'zyz'};
    models(i).rotSeqOut = {'zyx', 'yxz'};
    if isScapula
        models(i).dofToShow = 10:12;
        models(i).dofToShowNames = {'Protraction', 'Upward rotation', 'Anterior tilt'};
        models(i).dofToShowFactor = {180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'degrees', 'degrees', 'degrees'};
    else
        models(i).dofToShow = [13:15 16:18]; 
        models(i).dofToShowNames = {'M-L Translation', 'A-P Translation', 'Upward Translation', 'Flexion', 'Abduction', 'Axial rotation'};
        models(i).dofToShowFactor = {1000, 1000, 1000, 180/pi, 180/pi, 180/pi};
        models(i).dofToShowYLabel = {'mm', 'mm', 'mm', 'degrees', 'degrees', 'degrees'};
    end
    models(i).rightToLeft = {-2 -4 -6 -8 -11 -12}; 
    models(i).GHrot = 16:18;
    models(i).folder = '';
    models(i).color = '';

    % Select the relevent models (and add colors)
    idxToKeep = nan(length(modelToUse), 1);
    for i = 1:length(modelToUse)
        for iM = 1:length(models)
            if models(iM).number == modelToUse{i}{1}
                idxToKeep(i) = iM;
                break
            end
        end
    end
    models = models(idxToKeep);
    
    
    for iM = 1:length(modelToUse)
        models(iM).folder = modelToUse{iM}{2}; % Select the folder
        models(iM).color = modelToUse{iM}{3}; % Select the colors
    end
    
end
