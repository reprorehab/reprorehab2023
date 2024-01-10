% Writing functions
% Written by Devin Austin and Jinseok Oh
% for ReproRehab POD1 learners, 11/13/23

clear all
clc

% We will practice writing functions and look at
% different features you may find useful.

% Let's first understand the use of `varargin`,
% that was briefly introduced in Week6 (Devin introduced)
% According to MATLAB's documentation:
% (https://www.mathworks.com/help/matlab/ref/varargin.html)
%
% `varargin` is an input variable in a function definition
% that enables the function to accept any number of input arguments. 
% Specify varargin by using lowercase characters. (point 1)
% After any explicitly declared inputs,
% include varargin as the last input argument.    (point 2)

%% varargin: the name is ORIGINAL
% Point 1 requires you to use lowercase characters. This means that
% only 'varargin', not 'Varargin', 'varArgin', or any other variation
% of 'varargin', will be recognized by MATLAB. Test if for yourself
% by running the two lines below:

varargin    % This will return nothing
varArgin    % This will return the error msg


%% The right position of varargin
% Point 2 asks you to place `varargin` as the last input argument of
% a function. So when declaring a function,
%
%   function do_something(x, y, varargin)
%
% is correct use of `varargin` whereas
%
%   function do_other_thing(varagin, x, y)
%
% is not. Let's check the example below.

% `returnResponseWrong` takes two inputs in the following order:
%   (varargin, x)
% and returns the string:
%   '{x} and {length(varargin)} more variables provided'
%
% `varargin` is supposed to take ANY number of inputs. MATLAB notices
% that there's another input `x` after `varargin`. It simply cannot
% distinguish the last input for `varargin` from the input for `x`! 
% Hence, it treats `varargin` as an input of length 1.

% Do you think the output of this line will be the following?
%   'hello and 4 more variables provided'
% Check it for yourself!
returnResponseWrong('mind', 2, 'me', 1, 'hello')

% What about this line? Did you expect this line to be printed?
%   'hello and 1 more variables provided'
% Can you tell why you are getting the result you see?
% (ft. check what you get from `length('mild')`)
returnResponseWrong('mild', 'hello')

% In contrast, `returnResponseRight` also takes two arguments and returns
% the same string as `returnResponseWrong` does, but the order of the
% arguments is:
%   (x, varargin)
% Does it now generate the result you expect?
returnResponseRight('mind', 2, 'me', 1, 'hello', 22)

% Also check this video to learn more about `varargin` (and `nargin`):
% https://www.mathworks.com/videos/varargin-and-nargin-variable-inputs-to-a-function-97389.html


%% Indexing varargin
% If you use `varargin`, how do you index this list within your function?
% It puts all input arguments into a **cell** array. Ring a bell?
% Please check line 6 (and the rest) of accessVarArgIN.m and guess
% what will be the output when you run these lines.
% Try changing the value of `argidx` as well and rerun this section!
argidx = 3;
accessVarArgIN(argidx, 'can', 'you', 'guess', 'which', 'character', 'output',...
    'is', 'going', 'to', 'be', 'returned', '?')


%% Throwing an error message
% When people misuse your function, you should (gently) WARN them!
% Please check line 2-3 of accessVarArgIN.m and see how `error()` is used.
% 
% An error message can help users more by reminding them their mistakes.
% Can you comment line 3, uncomment line 4 of the original function file, 
% save it, and run the line below?
% 
% Can you check what is the type you provided for the 'index' of
% `accessVarArgIN` function ('SECOND')? 
accessVarArgIN('SECOND', 'now', 'you', 'will', 'read', 'the', 'error',...
    'message!')

% You now can even set an error message!
% What else in MATLAB do you need to be afraid of?


%% How to pre-define optional arguments: Background
% Remember how `varfun()` had optional arguments such as
% 'InputVariables' or 'GroupingVariables'?
%
% >> help varfun
% ...
% B = varfun(FUN, A, 'PARAM1', val1, 'PARAM2', val2, ...) allows you
% to specify optional parameter name/value pairs to control how varfun
% uses the variables in A and how it calls FUN.
%
% How does `varfun()` know if a user provides 'PARAM1', val1,...
% 'PARAM2', val2, and so on?
% Please run the line below and check the very first line
edit varfun

% You can see that the function `varfun is declared as:
%
%   function b = varfun(fun,a,varargin)
%
% So anything after the two arguments, `fun`(a function to apply) and 
% `a` (a table where the function will be applied), additional input 
% will all be put inside `varargin`, a cell array.
% `varfun()` will later 'parse' this cell array.
% 
% This parsing is possible through `inputParser`.

% Devin introduces this when he goes over Week6 activity.
% For reference, you can check this page:
% https://www.mathworks.com/help/matlab/matlab_prog/parse-function-inputs.html


%% How to pre-define optional arguments: Practice
% Let's revisit 'PlotSignificantDifference.m' of Week6.
% In summary, you have 6 'Required' inputs and `varargin`,
% the last input of the function.
% Let's simulate what is happening inside the function, using
% `SimplifiedFunction.m`, a function based on Devin's code snippet.
% This function takes exactly the same inputs as 
% `PlotSignificantDifference` function does and returns the inputParser p.
%
% function p = SimplifiedFunction(Axis,X1,X2,Y,Height,pValue,varargin)

% Assign some random values for 'Required' inputs.
Axis = 1;
X1 = 3;
X2 = 4;
Y = 5;
Height = 0.2;
pValue = 0.001;
% 'Optional' inputs are 'Symbol' and 'alpha'.
% Let's suppose we're not providing them for now.
% When using `SimplifiedFunction`, the command will be like:
%   SimplifiedFunction(Axis, X1, X2, Y, Height, pValue)
% with no value for `varargin`. This is equal to setting `varargin` 
% an empty cell array (refer to line 75!!)
varargin={};
% pre-defined values of 'Symbol', and 'alpha'
defaultSymbol = '*';
defaultAlpha = 0.05;

% Define an inputParser
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
% See how `defaultSymbol` and `defaultAlpha` values are used
% in case these optional inputs are NOT provided by the user.
% If no user input is provided, these default values are used.
addOptional(p, 'Symbol', defaultSymbol);
addOptional(p, 'alpha', defaultAlpha);  

% If you run this line, you are generating `fields` of a `struct`,
% p.Results.
parse(p,Axis,X1,X2,Y,Height,pValue,varargin{:});

% Let's check what are in p.Results
p.Results
% A field can be reached by dot indexing. The field `Symbol` will have
% its default value: defaultSymbol (= '*')
p.Results.Symbol

% Check if you get the same result with the following lines
% Can you recognize that there is nothing for `varargin` here???
p2 = SimplifiedFunction(Axis,X1,X2,Y,Height,pValue);
p2.Results.Symbol

% Should you provide optional inputs...
p3 = SimplifiedFunction(Axis,X1,X2,Y,Height,pValue,'Symbol','++');
p3.Results.Symbol

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXERCISE
% Can you replicate this behavior with p? In other words, can you make
% the command: p.Results.Symbol to return '++'?

clear p % erase 'p' first.
varargin=...;
% Then rerun lines 158-183 (Define a new inputParser named p,
% add parameters, and parse it).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% What about another optional input, 'alpha'? What is this value?
p3.Results.alpha

% Without running these lines, can you guess p4.Results.alpha?
p4 = SimplifiedFunction(Axis,X1,X2,Y,Height,pValue,'alpha',1e-4);
p4.Results.alpha


%% FINALE - WRITE YOUR OWN FUNCTION
% Let's write a function to check if you've understood everything!
% Your task is to complete the script: MyCrystalBall.m

% Your function will be declared in this way:
%   function myAnswer = MyCrystalBall(tbl, varargin)

% Unfortunately, your crystal ball is not omnipotent and you can ask
% limited number of questions.
% Please type below to check details.
%
% >> help MyCrystallBall

% Your crystal ball will read a table reading dailyActivity_merged.csv.
% This is a dataset of FitBit Fitness Tracker Data I downloaded from
% https://zenodo.org/records/53894

% tbl is a table of 940 rows and 15 columns
tbl = readtable('dailyActivity_merged.csv');

% The first column, Id, will be a categorical variable
tbl.Id = categorical(tbl.Id, unique(tbl.Id));

% The second column, ActivityDate, is a `datetime` array.
% This is the only data type we didn't introduce in our discussions.
% Please check 'help datetime' later. For this example, we will just
% drop this column, because it just confuses you...
tbl = removevars(tbl, "ActivityDate");

% Now, see if your crystal ball can answer your questions
% Remember, tbl is now a 940 x 14 table.

% Q0. A simple test - are these lines behaving as expected?
MyCrystalBall(tbl);

% Q1. This should return a 2x14 table
%
%     Id        TotalSteps    ...
% ----------    ----------   -----
% 1503960366       13162     ...
% 8877689391        4790     ...
ans1 = MyCrystalBall(tbl, 'rowindex', [1, 930]);
ans1

% Let's test error messages under different scenarios
% Q2a. This should return a custom error message:
%   '3 incorrect row indices were provided'
MyCrystalBall(tbl, 'rowindex', [2, 40, 0, 990, 1100]);

% Q2b. This time it's column related message:
%   '2 incorrect column indices were provided'
MyCrystalBall(tbl, 'colindex', {'TotalSteps', 'ReproRehab', 'POD1'})

% Q2c. Finally, both row and column related message:
%   ' 3 incorrect row and indices and
%     2 incorrect column indices were provided'
MyCrystalBall(tbl, 'rowindex', [2, 40, 0, 990, 1100], ...
    'colindex', [0, 16])

% Q3. A column index can be of different formats: `char` or `double`
% These two line are identical interms of what they return
MyCrystalBall(tbl, 'colindex', 2)
MyCrystalBall(tbl, 'colindex', 'TotalSteps')

% Q4. Multiple character indices can be provided too.
MyCrystalBall(tbl, 'colindex', {'TotalSteps', 'TotalDistance'})

% Getting summary statistics in different scenarios
% Q5a. statistics of only certain columns, without a grouping variable
%
% Expected result is a 1x2 table:
%
%   TotalSteps      TotalDistance
%   ----------      -------------
%     7637.9            5.4897
ans2 = MyCrystalBall(tbl, 'summary', 'mean', 'colindex',...
    {'TotalSteps', 'TotalDistance'});
ans2

% Q5b. statistics of certain columns and rows, without a grouping variable
%
% Expected result is a 1x2 table:
%
%   TotalSteps      TotalDistance
%   ----------      -------------
%     7050.1            4.822
ans3 = MyCrystalBall(tbl, 'summary', 'mean', 'colindex',...
    {'TotalSteps', 'TotalDistance'}, 'rowindex', [1:10, 30:80]);
ans3

% Q5c. statistics of certain rows without a grouping variable
%      can you explain why tbl(:, 2:end), not tbl is provided?
%
% Expected result is a 1x13 table:
%
%   TotalSteps   TotalDistance  TrackerDistance   ...
%   ----------   -------------  ---------------  -----
%      7546          5.22             5.22        ...
ans4 = MyCrystalBall(tbl(:, 2:end), 'summary', 'median', 'rowindex', 1:100);
ans4

% Q5d. statistics with everything specified.
%
% Expected result is a 19x3 table:
%
%       Id      TotalSteps  TotalDistance     ...
%   ----------  ----------  ---------------  -----
%   1503960366    3052.5        1.9842        ...
%   1624580081      6177        4.7962        ...
%       ...         ...           ...         ...
MyCrystalBall(tbl, 'summary', 'std', 'groupby', 'Id', 'colindex',...
    {'TotalSteps', 'TotalDistance'}, 'rowindex', [1:100, 300:500, 600:780])

% Basically, the reult should be similar to the output of these lines.
subset = tbl([1:100, 300:500, 600:700], {'Id', 'TotalSteps', 'TotalDistance'});
grpstats(subset, 'Id', 'std')

% Extra: if your 'groupby' is not categorical, your crystal ball should
% spit an error
MyCrystalBall(tbl, 'summary', 'std', 'groupby', 'TotalSteps')

% Extra 2: if you provide 'groupby' but not 'summary', do you see an error?
% If not, can you explain why?
MyCrystalBall(tbl, 'groupby', 'Id')