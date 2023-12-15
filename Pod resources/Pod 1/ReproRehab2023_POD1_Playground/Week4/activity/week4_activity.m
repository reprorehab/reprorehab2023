% This week's activity is designed to help you practice
% manipulating tabular data, focusing on:
%   1) reading a complex table with MATLAB's import options
%   2) changing variable names
%
% After this activity, I expect you to have the working knowledge of
%   1) the table properties in general (ex. variable names)
%   2) how to use for/while loop effectively, according to your needs
%   3) how to use the function handle when needed
%
% Prepared for ReproRehab2023 POD1, 10/25/23
% by Jinseok Oh

% Ok, so you will read a spreadsheet
FileToRead = 'JumpData.xlsx';

% You may say: I don't know anything so will just call the function
% without specifying a THING (AND THOU SHALT BE PUNISHED!)
viconOutput1 = readtable(FileToRead);

% You're confused after checking how `viconOutput1` looks like.
% So you ask MATLAB to figure out something.
opts = detectImportOptions(FileToRead)

% Ok, you see bunch of `Properties`.
% These properties will be used in reading the file 'properly'.
% Let's check if MATLAB has done it right.
% The message says at the end: "To display a preview of the table,
% use preview" (this won't show the full table).
% Let's check it out using the variable `opts`.
preview(FileToRead, opts)

% 1. You have two sheets in the xlsx you read.
%    You may want to specify which sheet you want to read 
%    by setting `Sheet` parameter.
opts.Sheet = 'Model Outputs';
opts
% 2. Then your values start from the sixth-row.
% Right now `DataRange` is set to 'A5'.
opts.DataRange
% This should be replaced with 'A6'.
opts.DataRange = 'A6';
% 3. `opt` says that VariableNamesRange is 'A3'
% If you check the xlsx file, the third row does contain some
% meaningful variable names.
% However, do keep in mind that this is where your knowledge about
% a specific file you're reading may be helpful.
% Some variables have three subordinate columns, while others have
% nine of those. For example, you should 'know' that when there are 
% three subordinate columns, each column stands for the x, y, or z axis.
% 4. There are some NULL Properties. You can fill them in as needed.

%%%%%%%%%%
% Q0. Let's set property `VariableUnitsRange` as 'A5'
%%%%%%%%%%
% A0 HERE!

% Ok, then let's preview again with the updated `opts`.
preview(FileToRead, opts)

% Finally, let's read the file
viconOutput2 = readtable(FileToRead, opts);

% Before moving any further, let's check the warning message,
% (Don't run away from interpreting error/warning messages!)
%
% Warning: Column headers from the file were modified to make them
% valid MATLAB identifiers before creating variable names for the table.
% The original column headers are saved in the VariableDescriptions property.
% Set 'VariableNamingRule' to 'preserve' to use the original column headers 
% as table variable names.
%
% Please check the variable names of viconOutput2.
% What's the MATLAB command to return the name of the third column?
viconOutput2.Properties.VariableNames{1,3}

% We can check the original name of this variable.

%%%%%%%%%%
% Q1. What's the MATLAB command to return the original variable names?
%     (Hint. The warning message said: check `VariableDescriptions` property /
%     copy line 58 and change ONE thing!) 
%%%%%%%%%%
% A1 HERE!

%%%%%%%%%%
% Q2. How do the Variable Descriptions compare to the actual variable names
%     in the JumpData.xlsx?
%%%%%%%%%%
% A2 HERE! Please write your answer as a comment.

%%%%%%%%%%
% Q3. Let's replace some of the meaningless variable names with 
%     meaningful ones.
%     Let's put down 'Frame' for the first column name and 'Sub_Frame' 
%     for the second column name.
%     (Hint. You need TWO lines of code to do this)
%%%%%%%%%%
% A3 HERE!

% For the rest, you may first want to identify the measurement axis.
% For example, LAbsAnkleAnlge has three axes: X, Y, and Z.
% On the other hand, LFE has nine axes: 
%   - Rotation X, Y, and Z (RX, RY, RZ)
%   - Translation X, Y, and Z (TX, TY, TZ)
%   - Reference distances (SX, SY, SZ)
% What about we add these at the end of the current variable names?
% ex. 'JO_LAbsAnkleAngle' -> 'JO_LAbsAnkleAngle_X'
%     'Var4' -> 'JO_LAbsAnkleAngle_Y'
%
% There can be many different ways to accomplish the goal, but I can think
% of this approach (This is a brute-force method and not at all elegant):
%   1) Save the first two variable names ('Frame' and 'Sub_Frame'),
%      replace each variable name 'VarN' with '' (an empty char array).

%%%%%%%%%%
% Q4. Let's first create a new variable (origVarnames) that saves 
%     the variable names EXCEPT THE FIRST TWO NAMES.
%     (Hint. use `end` to indicate the end of an array
%     >> sampleArray = [1,2,3,4,5];
%     >> sampleArray(3:end)    % This will return [3, 4, 5]
%     Note. Please check how (), not {} is used for this case.
%           If you want to return a cell array of char entries, use ().
%%%%%%%%%%
% A4 HERE!

%%%%%%%%%%
% Q5. Then apply `cellfun` to use the `blankfill` function I prepared 
%     in advance and save the output to another variable `interimVarnames`.
%     You only need to delete '%A5 HERE' and type the command to call
%     the function as a function handle.
%     (Hint. Recall how to use a function handle!)
interimVarnames = cellfun(%A5 HERE,...
    origVarnames, ....
    'UniformOutput', false);
%%%%%%%%%%

%   2) Iterate through the variable names and...
%      (Here I used while-loop, not for-loop, because I planned to skip the
%      index when needed. You cannot do so with a for-loop.)
idx = 1;
while idx <= length(interimVarnames)
    viconidx = idx + 2;
%       2-1) if a variable name is not '', count how many '' follow.
%            (How can you count it though? A simple way can be checking
%             the values of the next three items. If all three are empty,
%             you can safely assume for this exercise that the following
%             EIGHT elements are empty.)
    if ~isempty(interimVarnames{1,idx})
        numEmpty = sum(cellfun(@isempty, interimVarnames(idx+1:idx+3)));
%           2-1A) if the number (`numEmpty`) is 2,
        if numEmpty == 2
%               2-1A-1) add '_X' to the current name and set it as the name
%                       of the current column.
            viconOutput2.Properties.VariableNames{viconidx} = [interimVarnames{idx}, '_X'];
%               2-1A-2) add '_Y' to the current name and set it as the name
%                       of the next column.
            viconOutput2.Properties.VariableNames{viconidx+1} = [interimVarnames{idx}, '_Y'];
%               2-1A-3) add '_Z' to the current name and set it as the name
%                       of the third column.
            viconOutput2.Properties.VariableNames{viconidx+2} = [interimVarnames{idx}, '_Z'];

            % and we'll skip the index by 2! Don't forget to increase it
            % or you will loop FOREVER.
            idx = idx + 3;
%           2-1B) if the number is greater than 2,
        elseif numEmpty > 2
%               2-1B-1) add '_RX' to the current name and set it as
%                       the name of the current column.
            viconOutput2.Properties.VariableNames{viconidx} = [interimVarnames{idx}, '_RX'];
%               2-1B-2 ~ 9) add one of ['_RY', '_RZ', '_TX', '_TY', '_TZ',
%                           '_SX', '_SY', '_SZ'] to the current name and set
%                           that as the name of the following columns.
            suffix = {'_RY', '_RZ', '_TX', '_TY', '_TZ', '_SX', '_SY', '_SZ'};
%%%%%%%%%%            
% Q6. Can you try using a for loop to finish the task?
%%%%%%%%%%
            for % A6a HERE: specify a new index (eg. ii) and its range.
                % A6b HERE: attach the ii-th suffix to the current variable
                % name and save it as a new variable name (2-1B-2 ~ 9).
                % Refer to 2-1A-1, 2-1A-2, or 2-1A-3 to write the code.
            end
            % and we will skip the index by 8!
            idx = idx + 9;
        else
            % Just for fun, eh? This loop should NOT break.
            disp('Ah, something must have gone wrong')
            break
        end
    end
end

% Now check for yourself if the variable names look PROPER
viconOutput2.Properties.VariableNames

%%%%%%%%%%
% Q7. Can you use cellfun one more time to remove the prefix: 'JO_' from
%     the variable names?
%     Let's try using the `renamevars` function. You should use it like
%     >> table = renamevars(table, current VariableNames, new VariableNames);
%     So Answer 7a should be something you're familiar with.
%     Answer 7b and 7c are the two arguments provided to `cellfun()`
%     For A7b, x will be the input and x is assumed to be a `char` array.
%     Think of how you can parse a char array and take some elements of it.
%     (Hint 1. Please read at blankfill.m and check how the input of the
%      function is parsed. Another example is also in char_and_strings.m)
%     Then think of an anonymous function that will take a `char` input 
%     x and return the portion of x ranging from 
%     the index 3 to the end of the original array.
%     (Hint 2. Please read matlab_tips.m, the paragraph that describes the
%      use of function handles!)
%     A7c should be a easy one if you can understood the mechanism of 
%     `cellfun`.
%     (Hint 3. There are two variable names, 'Frame' and 'Sub_Frame' that
%      don't have the prefix 'JO_'. They should not be included in this
%      transformation. Please take that into consideration. They are the
%      FIRST TWO names.)
% Yes, this is not a very meaningful exercise, but devised to FORCE you to
% practice one more time. `renamevars` function is more useful to change 
% a single or several variable names.
%%%%%%%%%%
viconOutput2 = renamevars(viconOutput2,...
    % A7a HERE,...
    cellfun(% A7b HERE, A7c HERE,...
    'UniformOutput', false));

% Check one more time if 'JO_' has been dropped.
viconOutput2.Properties.VariableNames

%%%%%%%%%%
% Q8. [Optional] So far we've been talking about doing reproducible
%      science. The significance of rich, structured metadata describing
%      your actual dataset is what the FAIR principle stresses.
%      Can you make a JSON file describing what are the first THREE
%      variables, their units, and their measurement axes? 
%      (Hint 1. If you have cloned the forked repo, 'Week1' folder
%      should have 'create_json.m' file. Use the script to create the
%      JSON file.)
%      (Hint 2. Which 'Property' of 'viconOutput2' will show you the
%      'VariableUnits???')    
%%%%%%%%%%