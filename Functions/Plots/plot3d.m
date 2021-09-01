function h = plot3d(varargin)
% PLOT3D is an easy interface to plot and plot3, that dispatch
% and update graph for you (basically things you spend a lot of time
% writing and rewriting). Just add a 'd' to your plot3 and get rid of all
% these anoying set()!
%
% SYNTAX 
%   h = PLOT3D(M) plots the matrix M which is a column 2xN, 3xN or 4xN matrix. 
%     Note that the 4th line is ignore (this is a line of 1)
%   h = PLOT3D(h, M) update a specific plot (h) with new values.
%   h = PLOT3D(M, h) update a specific plot (h) with new values.
%   h = PLOT3D(h, 'option', value) throws options to plot3 (all plot3 option are available)
%   h = PLOT3D(h, M, 'option', value) create/update a plot with new values M 
%        and throws options to plot3 (all plot3 option are available)
%   h = PLOT3D(M, h, 'option', value) create/update a plot with new values M 
%        and throws options to plot3 (all plot3 option are available)
%   h = PLOT3D() prepare a handler on a plot
%   h = PLOT3D('options', value) prepare a handler on a plot with options thown to plot3
%    
% EXAMPLE
%   h = plot3d(rand(3,100), 'linewidth', 5);        % Create a new graph
%   plot3d(h, rand(3,100));                         % Update values
%   plot3d(rand(3,100), h);                         % Update values again
%   plot3d(h, 'linewidth', 2);                      % Change options
%
% DISCLAIMER and COPYRIGHT
%   This function was written by 
%                             Pariterre
%                             laboratoire S2M
%                             Université de Montréal
%   Version 1.0 : April 13th, 2016
%   Version 1.1 : Corrected a bug when exotic options are sent

    % Parsing arguments
    % If no argument, just prepare a new graph
    if isempty(varargin)
        h = plot3(nan, nan, nan);
        return;
        
    % If first argument is a matrix and handler is on second position (or not provided) 
    elseif isnumeric(varargin{1})
        matrixIDX = 1; % The data are on 1st vararging
        if length(varargin)<2 || sum(~ishandle(varargin{2})) == numel(varargin{2})
            % If no plot handler is provided, create one
            h = plot3(nan, nan, nan, varargin{2:length(varargin)}); % Throw options now, so weird options formatting is taken in account automatically
            optionxIDX = []; 
        else
            h = varargin{2};
            optionxIDX = 3:length(varargin); % Options are 2 to end
        end
        
    % If the first argument is a the handle and the matrix is in second position (or not provided)
    elseif sum(ishandle(varargin{1})) == numel(varargin{1})
        % Get the handler on the plot
        h = varargin{1};
        % Check if data are 2nd or not provided
        if length(varargin)>=2 && isnumeric(varargin{2})
            matrixIDX = 2; % The data are on 2nd vararging
            optionxIDX = 3:length(varargin);
        else
            matrixIDX = 0; % There is no data to plot/update
            optionxIDX = 2:length(varargin);
        end
        
    % If only options are received, create a new empty graph with these options 
    elseif ischar(varargin{1}) && length(varargin) > 1
        h = plot3(nan, nan, nan, varargin{1:length(varargin)}); % Throw options now, so weird options formatting is taken in account automatically
        matrixIDX = 0;
        optionxIDX = [];
        
    % If we get here, something went wrong in argument parsing
    else
        error('First argument must be either a matrix, a handler on plot3d or plot3 options')
    end 
    
    % Update graph data
    if matrixIDX
        % If matrix is a 2D add a zeros line
        if size(varargin{matrixIDX},1) == 2
            M = [varargin{matrixIDX} zeros(1, size(varargin{matrixIDX},2))];
        elseif size(varargin{matrixIDX},1) > 2
            M = varargin{matrixIDX};
        else
            error('Matrix should be a 2xN, 3xN or a 4xN matrix')
        end
        set(h,  'xdata', M(1,:), ... Change x, y and z data
                'ydata', M(2,:), ...
                'zdata', M(3,:));
    end
        
    % Throw other options to plot3
    if ~isempty(optionxIDX)
        set(h, varargin{optionxIDX}); 
    end
    
    % Clear output if not needed
    if nargout == 0
        clear h
    end
end
