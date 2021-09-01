function param = modelReconsParam(model)
% model est le numero du model
% UseEllips2 n'est utile que pour les modeles d'epaule

switch model
    case 1 % SkinAndBrace model: Scapula/Humerus using skin markers without the pins 
        % All the markers except for technical ones
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = 6:8;
        
    case 1.1 
        % Only deltoid and epicondyles for the humerus
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 10:13 16:25]; 
        
    case 1.2
        % Only brace for the humerus
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 9:19]; 
        
    case 1.3
        % Only forearm and brace and epicondyle for the humerus
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 9:13 18:19];
        
    case 1.4
        % Arm no brace for the humerus
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 18:25];
        
    case 1.5
        % Only hu1 and forearm no brace for the humerus
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 10:13 18:25];
        
    case 1.6
        % Only deltoid and epicondyles for the humerus, then rereconstruct
        % the translations with only the medial marker
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [6:8 10:13 16:25]; 
        
        param.qutilises{2} = [1:3 7:9];
        param.qbloques{2} = [];
        param.MarkFaux{2} = [6:8 11:25]; 
        
    case 2 % Pins model: Scapula/Humerus using pins markers without the skin markers
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = [5:8 13:14];
        
    case 3 % Brace model: Scapula/Humerus using brace markers without the pins 
        % All the markers except for technical ones
        param.qutilises{1} = [1:6 7:12];
        param.qbloques{1} = [];
        param.MarkFaux{1} = 6:8;
        
    case 12 % Model 1 with the (unused) pins markers from 2 (only for vizualisation)
        param.qutilises{1} = [];
        param.qbloques{1} = [];
        param.MarkFaux{1} = []; 
        
    case 21 % Model 2 with the (unused) SkinAndBrace markers from 1 (only for vizualisation)
        param.qutilises{1} = 1:12;
        param.qbloques{1} = [];
        param.MarkFaux{1} = [5:12 17:33]; 
        
    case 23 % Model 2 with the (unused) Brace markers from 3 (only for vizualisation)
        param.qutilises{1} = [];
        param.qbloques{1} = [];
        param.MarkFaux{1} = []; 
        
    case 32 % Model 3 with the (unused) pins markers from 2 (only for vizualisation)
        param.qutilises{1} = [];
        param.qbloques{1} = [];
        param.MarkFaux{1} = []; 
        
        
    otherwise
        error('Wrong model selection')
        
end

param.MarkW = [];
param.NDDL = 12;