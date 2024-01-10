function charoutput = accessVarArgIN(index, varargin)
    if ~isnumeric(index)
        error('index should be a number: ex) 1.')
        %error('Error. \nIndex must be a double, not a %s.', class(index))
    end
    charoutput = varargin{index};
end