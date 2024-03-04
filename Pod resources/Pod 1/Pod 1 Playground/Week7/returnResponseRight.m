function out = returnResponseRight(x, varargin)
out = [x, ' and ', num2str(length(varargin)) ' more variables provided'];
end