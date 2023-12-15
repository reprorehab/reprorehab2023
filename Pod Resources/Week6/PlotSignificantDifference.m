%-----------
% JF code modified by Devin Austin
%--------------------------------------------------------------------------
function PlotSignificantDifference(Axis,X1,X2,Y,Height,pValue,varargin)
% This local function is used to add annotations to our plot to denote
% statistically significant differences. This type of annotation is
% commonly added using an external application like Adobe Illustrator, but
% if you are clever, then you can add all the annotations you need within
% MATLAB. 
    
% Set default values for optional parameters
    defaultAlpha = 0.05;
    defaultSymbol = '*';

    % initiate an input parser
    p = inputParser; 

    % Add all parameters to the input parser
    %%%Reuired:
    addRequired(p, 'Axis');
    addRequired(p, 'X1');
    addRequired(p, 'X2');
    addRequired(p, 'Y');
    addRequired(p, 'Height');
    addRequired(p, 'pValue');
    %%% Optional:
    addOptional(p, 'Symbol', defaultSymbol);
    addOptional(p, 'alpha', defaultAlpha);  

    parse(p,Axis,X1,X2,Y,Height,pValue,varargin{:}); 

    % Check if the p value is not significant
    if pValue >= p.Results.alpha
        % If not, initaite this return statement which exits the function
        return
    end

% Make sure that the appropriate axis is active and that the data won't be
% erased from the axis
    get(Axis)
    hold on

% Build annotation by adding vertical and horizontal lines of defined
% length, width, or height
    l1 = line([X1 X1],[Y Y+Height]); set(l1,'Color','k')
    l2 = line([X2 X2],[Y Y+Height]); set(l2,'Color','k')
    l3 = line([mean([X1 X2]) mean([X1 X2])],[Y+Height Y+2*Height]); set(l3,'Color','k')
    l4 = line([X1 X2],[Y+Height Y+Height]); set(l4,'Color','k')

% Add an asterisk to denote statistical significance
    text(mean([X1 X2])-0.05, Y+2.1*Height, p.Results.Symbol,'FontSize',14)

end