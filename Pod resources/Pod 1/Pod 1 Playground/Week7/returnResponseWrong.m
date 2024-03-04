function out = returnResponseWrong(varargin, x)
out = [x, ' and ', num2str(length(varargin)) ' more variables provided'];
end