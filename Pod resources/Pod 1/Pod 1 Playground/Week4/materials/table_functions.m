% read a csv file as a table
test = readtable('motion.csv');

% check the column names
test.Properties.VariableNames
% This is a cell array, so use {} for indexing
test.Properties.VariableNames{1,3}

% check the size of the table?
size(test)
% You can view it separately: height and width
height(test)
width(test)

% dot index a column variable
test.lhipjoint_x

% You can use the dot indexing to create
% a new column.
test.samplenumber = (1:height(test))';

% Let's add a categorical variable too.
acount = ceil(height(test)/2);
groupvec = vertcat(repmat('A', acount, 1), ...
    repmat('B', height(test)-acount, 1));
% MATLAB asks you to convert the char array `groupvec` to
% cell and then convert to categorical.
test.group = categorical(cellstr(groupvec));

% If you want to apply a function to the
% columns of a table, use `varfun`
% If you want to apply the mean of each column,
varfun(@mean, test)
% Eh, error! What shall we do? Let's read the error msg.
%
% Error using tabular/varfun>dfltErrHandler
% Applying the function 'mean' to the variable 'group' generated the following error:
%
% Invalid data type. First argument must be numeric or logical.
% ...
%
% Ok, so basically you cannot get the mean of `group`, the categorical variable.
% What can be the workaround? You can provide the subset of the table,
% excluding the `group` column. There can be different ways to subsetting
% the original dataset.
% 1) If you know that the `group` column is located at the end,
%    you can include columns 1 to width(test)-1.
varfun(@mean, test(:, 1:width(test)-1))
% 2) What if `group` is somewhere in the middle and you don't know
%    the exact location of it? You can use the VariableNames property.
idx = ~contains(test.Properties.VariableNames, 'group');
varfun(@mean, test(:, idx))
% 3) What about you apply the mean function to columns that contain
%    numerical values?
idx2 = vartype("numeric");
varfun(@mean, test(:, idx2))

% If you want median values of specific columns,
% use 'InputVariables' parameter.
varfun(@median, test, 'InputVariables', ["root_x", "root_y", "root_z"])
% Let's suppose you want to get group means of the columns.
% Then use 'GroupingVariables' parameter.
varfun(@mean, test, 'GroupingVariables','group')

% There are other functions similar to varfun.
% what about `rowfun`? Can you guess what it does?
rowfun(@(x)median(x), test(:, 1:3), 'SeparateInputs', false)
rowfun(@(x)sum(x), test, "InputVariables", ["head_x", "head_y", "head_z"],...
    'SeparateInputs', false)
% If you know the number of columns you're trying to apply the function,
% specifying the number completes the job faster.
rowfun(@(x,y,z)sum([x,y,z]), test, "InputVariables",...
    ["head_x", "head_y", "head_z"])

% We'll look at what function-handles are in a different script
fh = @(coeff, x)sum(coeff.*x);
rowfun(@(x)fh([0,1,0],x), test(:, 4:6), 'SeparateInputs', false)

% Other functions to manipulate data in table are:
%   - addvars
%   - movevars
%   - removevars
%   - splitvars
%   - convertvars
%   - and many more!

% If you're performing a similar job with an array: arrayfun
% With a cell array: cellfun

% If you want to replace the current column name
% with a new one (ex. root_x -> ROOT_X)
test = renamevars(test, 'root_x', "ROOT_X");
test.Properties.VariableNames{1}