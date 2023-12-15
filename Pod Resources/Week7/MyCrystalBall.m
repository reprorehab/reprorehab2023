function myAnswer = MyCrystalBall(tbl, varargin)
% MYCRYSTALBALL - Summary statistics organized by group
%
%   MYCRYSTALBALL(tbl) returns a message: 'This is a N x P table' 
%   where N, P are the height and the width of the table (tbl).
% 
%   myAnswer = MYCRYSTALBALL(tbl, 'PARAM1', val1, 'PARAM2', val2, ...)
%   allows you to specify optional parameter name/value pairs to control
%   how MYCRYSTALBALL uses the variables in tbl to prepare a subset
%   and calculate summary statistics for each column. Parameters are:
%
%       'rowindex'  - Specifies rows of tbl that will be subsetted.
%       'colindex'  - Specifies columns of tbl that will be subsetted.
%
%   'rowindex' and 'colindex' are each a positive integer or 
%   a vector of positive integers. 'colindex' can also be a variable name
%   or a cell or string array containing one or more variable names.
%
%       'summary'   - Specifies summary statistics to be calculated.
%                     Choose from the following: 'mean', 'median', 'std',
%                     or 'iqr'. Default is 'mean'.
%       'groupby'   - Specifies ONE variable in tbl that define groups
%                     of rows. Each group consists of rows in tbl that
%                     have the same combination of values. ex) 'id'
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Task 1: if-else-end statement.
    % If tbl is NOT a table, print an error message.
    % Use 'istable' to check if tbl is a table.
    % Check line 2 of accessVarArgIN.m
    if ...    % T1
        error('This is not a table but %s', class(tbl))
    % else, define variables: N, P, tblcolnames
    else
        [N, P] = size(tbl);
        tblcolnames = tbl.Properties.VariableNames;
    end
    
    % Task 2: Define an inputParser, add optional arguments,
    % and parse the intputParser.
    % Copy and modify lines in SimplifiedFunction.m
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % T2a. Define an inputParser 'p'
    p = ...

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % T2b. Add optional arguments with default values.
    % Optional arguments are:
    %   'rowindex': default is 1:N
    %   'colindex': default is 1:P
    %   'summary' : default is 'mean'
    %   'groupby' : default is ''
    addOptional(p, ..., ...);
    ...

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % T2c. Parse 'p'.
    parse(p, ...)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Task 3. Define summaryfnc based on the value of p.Results.summary.
    % For example, if p.Results.summary is 'mean', then summaryfnc is the
    % FUNCTION HANDLE of that function.
    % Check how you use `switch` by typing 'help switch'.
    % Dr. Finley also shows how switch-case is used in his video (19:30 ~)
    % https://youtu.be/8ztUP-BXinE?si=01yfI5H97pchstwA
    switch p.Results.summary
        case 'mean'
            summaryfnc = ...;
        case ...
            summaryfnc = ...;
        case ...
            summaryfnc = ...;
        case ...
            summaryfnc = ...;
        otherwise
            error('I do not understand your summary statistics: %s',...
                p.Results.summary)
    end

    % Task 4. First check if any additional argument is provided,
    % and act accordingly.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % T4a. If no optional argument is provided (this is equal to
    % varargin being empty; use isempty to check this), simply report
    % the number of rows and columns.
    if ...
        sprintf('This is a table with %d rows and %d columns',N, P)
    else
        % ughridx is the logical array (true or false) telling if
        % each element of p.Results.rowindex is greater than the height
        % of tbl (N) or less than or equal to 0.
        %
        % Example: tbl is a 30 x 4 table; N = 30
        %
        % >> MyCrystalBall(tbl, 'rowindex', [0, 1, 2, 3, 4, 100])
        %
        % If you successfully parsed p, the inputParser, p.Results.rowindex
        % will be [0, 1, 2, 3, 4, 100].
        % Each element of p.Results.rowindex is checked if greater than N,
        % 30 (check I), or smaller than or equal to 0 (check II).
        % The first operation will return 
        % A = [false, false, false, false, false, true] because
        % 100 is greater than 30.
        % The second operation will return
        % B = [true, false, false, false, false, false] because 
        % 0 is less than or equal to 0.
        % Finally, '|' is the OR operator (true | false = true).
        % A | B = [true, false, false, false, false, true].
        ughridx = p.Results.rowindex > N | p.Results.rowindex <= 0;
        
        % column indices can be a number / number array, a char array, or a
        % cell array.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % T4b. Check if p.Results.colindex is a number / number array
        % use isnumeric
        if ...
            % T4c. Define ughcidx which is the column equivalent of ughridx
            % This time check if p.Results.colindex is greater than the
            % width of the table (what is the variable??) or less than or
            % equal to 0.
            ughcidx = ...;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % T4d. Check if p.Results.colindex is char or a cell array of char;
        % use 2 functions (ischar, iscell) and '||' operator.
        % Your answer should be in the format: A || B. Please figure out
        % what A and B are.
        elseif ...
            % T4e. Check if each element of p.Results.colindex is
            % NOT(~) in tbl's current VariableNames.
            ughcidx = ...;
        end

        % Task 5. Print error messages for different scenarios
        % 
        % Example: ughridx = [true, false, false], ughcidx = [false, false]
        %
        % 'any': True if any element of a vector is a nonzero number of
        %        is logical 1 (TRUE)
        % any(ughridx) is 1 (true) and any(ughcidx) is 0 (false).
        %
        % 'all': True if all elements of a vector are nonzero.
        % all([any(ughridx), any(ughcidx)]) is equal to all([1, 0]), 
        % which is 0 (false).
        % So this is the scenario where there are at least one incorrect
        % row index and one incorrect column index are provided to the
        % function.
        if all([any(ughridx), any(ughcidx)])
            % 1) check how character arrays are concatenated using '[]'
            % 2) \n indicates line break.
            % 3) %d is an identifier for a number (integer).
            error(['%d incorrect row indices and\n' ...
                '%d incorrect column indieces were provided.'], ...
                sum(ughridx), sum(ughcidx))
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % T5a. If there is at least one incorrect row index,
        % print an error message: '%d incorrect row indices were provided'
        % where %d is the number of 1's of ughridx (ex. [1, 0, 0, 0])
        elseif ...
            error(...)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % T5b. If there is at least one incorrect column index,
        % print an error message:
        %   '%d incorrect column indices were provided'
        % with the value for %d properly defined.
        elseif ...
            error(...)
        else
            % If 'summary' was specified, then we will calculate the
            % summary statistic.
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % T5c. Define a variable, stringArgs
            % This will store all character arguments / values
            % a user provided.
            % For example,
            %
            % >> MyCrystalBall(tbl, 'rowindex', 1:100, 'summary', 'mean')
            %
            % then stringArgs is a 1x3 cell array:
            %   {'rowindex', 'summary', 'mean'}
            % (hint. use varargin and two functions: cellfun & ischar)
            stringArgs = ...;
            % Using stringArgs, define two more variables:
            %   userSummaryYes, userGroupByYes
            % The two variables tells if 'summary' or 'groupby' are
            % among stringArgs.
            userSummaryYes = contains('summary', stringArgs);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % T5d. Finish defining userGroupByYes
            userGroupByYes = ...;
            % If userGroupByYes is true (user provided 'groupby')
            if userGroupByYes
                % store the value of the parameter 'groupby' to userGString
                userGString = p.Results.groupby;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % T5e. If what's provided as the grouping variable is not
                % a categorical variable (use function: iscategorical),
                % return an error message:
                %   'Grouping variable is not a categorical variable'
                % Use 'userGString' to index the table and get the grouping
                % variable:
                %   tbl.(userGString)
                if ...
                    ...
                else
                    % `subset` is a subset of tbl defined by 
                    % the user provided row and column indices
                    subset = tbl(p.Results.rowindex, p.Results.colindex);
                    % subGroupVar is a categorical variable of `subset`.
                    % For example, let's suppose that tbl has one categorical
                    % variable, 'id'. You index this variable by:
                    %   tbl.id OR tbl.('id')
                    % Previously we defined userGString as the value of
                    % the function parameter, 'groupby', which is a 'char'
                    % array ('id' in the line below).
                    % >> MyCrystalBall(tbl, 'rowindex', 1:4, 'groupby', 'id')
                    % So tbl.(userGString) = tbl.('id') = tbl.id

                    % Let's also suppose that the 'id' column of tbl is a
                    % categorical variable with six entries: 4 A's and B's.
                    % From the example use of MyCrystalBall, we can guess
                    % that `subset` is tbl(1:4, :), a subset with the first
                    % four rows of tbl. This subset's 'id' column should be
                    % tbl.('id')(1:4) accordingly. Can you now understand
                    % why the first argument for `categorical` is this:
                    %   tbl.(userGString)(p.Results.rowindex)
                    % The second part, 
                    %   unique(tbl.(userGString)(p.Results.rowindex))
                    % has to do with the use of `categorical` function.
                    % You can refer to line 84 of Week6_activity.m
                    subGroupVar = categorical(tbl.(userGString)(p.Results.rowindex),...
                            unique(tbl.(userGString)(p.Results.rowindex)));
                    % unique values of subGroupVar
                    subGroupVarLabels = unique(subGroupVar);
                    % If no grouping variable in subset,
                    % add it to the subset table. The TWO scenarios where
                    % the condition here is not met will be either 1) user
                    % did not provide a value for 'colindex' or 2) the value
                    % of 'colindex' argument involves the index of the
                    % groupving variable (column) of tbl.
                    if ~contains(userGString, subset.Properties.VariableNames)
                        subset.(userGString) = subGroupVar;
                        % Bring userGString column to the left
                        subset = movevars(subset, width(subset), 'Before', 1);
                    end
                    % Preallocate memory
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % T5f. Define mem, a zero matrix whose height is equal
                    % to the number of unique values of subGroupVar, or the
                    % length of subGroupVarLables, and the width equal to
                    % the width of subset minus 1.
                    mem = ...;
                    % Nested for loop again! Hooray!
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % T5g. Write a nested for-loop to replace these lines.

                    % The nested for loop first takes a subset of `subset`,
                    % `subsetBy`. `subsetBy` has row values of the same
                    % grouping variable value. For example, if `subset` was
                    % like this and the {'groupby', 'id'} was provided,

                    % >> subset
                    % id    Var1    Var2
                    % ---   ----    ----
                    %  1     2.3     4.5
                    %  1     8.9     6.5
                    %  1     9.8    11.2
                    %  2     7.4     6.4
                    %  2     4.5     7.7

                    % The first `subsetBy` is the rows of `subset` whose
                    % grouping variable, 'id' is equal to the first
                    % element of the categorical variable, 'id', or 1.

                    % >> subsetBy
                    % id    Var1    Var2
                    % ---   ----    ----
                    %  1     2.3     4.5
                    %  1     8.9     6.5 
                    %  1     9.8    11.2

                    % Then the 'nested' loop will iteratively fill cells
                    % of the matrix `mem`. Each row of `mem` will store
                    % summary statistics of the variables of `subsetBy`.
                    % When all statistics are calculated and filled the
                    % zeros of one row of `mem`, you prepare another
                    % `subsetBy`, whose rows are the rows of `subset` where
                    % 'id' is equal to the SECOND element of 'id' or 2.

                    % Your nested for-loop will replace these lines below.
                    % These lines are describing what happens when `subset`
                    % has three 'id' values (ex. 'A', 'B', 'C') and two
                    % other variables (ex. 'Var1', 'Var2').
                    
                    % subsetBy = subset(subset.(userGString) == ...
                    %   subGroupVarLabels(1*), 2:end);
                    % mem(1*, 1**) = summaryfnc(table2array(subsetBy(:, 1**)));
                    % mem(1*, 2**) = summaryfnc(table2array(subsetBy(:, 2**)));
                    % subsetBy = subset(subset.(userGString) == ...
                    %   subGroupVarLabels(2*), 2:end);
                    % mem(2*, 1**) = summaryfnc(table2array(subsetBy(:, 1**)));
                    % mem(2*, 2**) = summaryfnc(table2array(subsetBy(:, 2**)));
                    % subsetBy = subset(subset.(userGString) == ...
                    %   subGroupVarLabels(3*), 2:end);
                    % mem(3*, 1**) = summaryfnc(table2array(subsetBy(:, 1**)));
                    % mem(3*, 2**) = summaryfnc(table2array(subsetBy(:, 2**)));

                    % '*' marks the first loop index. Define it as 'level'
                    % '**' marks the second loop index. Define it as 'col'

                    % 'level' should increase from 1 to WHAT? Look at where
                    % this index is used. That will give you the answer.
                    % What about 'col'? What is the range of this index?

                    % Iterate over the levels of the categorical variable
                    for level=1:...
                        ...
                        for col = 1:...
                            ...
                        end
                    end
                    % convert mem to a table
                    myAnswer = array2table(mem, 'VariableNames', ...
                        subset.Properties.VariableNames(2:end));
                    % add the categorical variable, and move it to left
                    myAnswer.(userGString) = subGroupVarLabels;
                    myAnswer = movevars(myAnswer, width(myAnswer), 'Before', 1);
                end
            % If 'groupby' was not used, but 'summary' and its value were
            % provided,
            elseif userSummaryYes
                % no grouping variable, so just get the summary stats
                subset = tbl(p.Results.rowindex, p.Results.colindex);
                mem = zeros(1, width(subset));
                % This would be a good hint to answer T5g.
                for col=1:width(subset)
                    mem(1, col) = summaryfnc(table2array(subset(:, col)));
                end
                myAnswer = array2table(mem, 'VariableNames',...
                    subset.Properties.VariableNames);
            else
                % If both 'groupby' and 'summary' are not provided,
                % at least one or both of 'rowindex' and 'colindex' are
                % provided. Return the subset of tbl using those indices.
                myAnswer = tbl(p.Results.rowindex, p.Results.colindex);
            end
        end
    end
end