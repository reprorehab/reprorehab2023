% The function blankfill will take a char (or string) array
% assuming the shape of 1-by-N where N > 3.
% The function will compare the first three elements
% of the given array to a template, 'Var', and return
% an empty char array if the elements match the template.
% Otherwise, the char array of the original input is returned.
% An input x will first be checked if it's a string array
% and if so, will be converted to a char array, just for the
% ease of parsing.
function out = blankfill(x)
    if isstring(x)      % check if the input x is a string array
        x = char(x);    % then convert to a character array.
    end                 
    if strcmpi(x(1:3), 'Var')   % Compare strings or character vectors
        out = '';               % If the first 3 letters are 'Var',
    else                        % out is '', an empty char array.
        out = x;                % Otherwise, out is the original value.
    end
end
