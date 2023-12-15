function p = SimplifiedFunction(Axis,X1,X2,Y,Height,pValue,varargin)
% Set default values for optional parameters
    defaultAlpha = 0.05;
    defaultSymbol = '*';

    % initiate an input parser
    p = inputParser; 

    % Add all parameters to the input parser
    %%%Required:
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
end