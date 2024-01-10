close all
clear
clc

%% Week 6 Pod 1-Performing statistical analysis & Visualization
%  Prepared for ReproRehab2023 POD1 by Devin Austin and Jinseok Oh, 11/10/23

% This week's activity is designed to introduce how to perform 
% basic statistical analysis and visualize the results effectively.
% Feel free to copy and modify parts of this script for your own work.

% The activity is based on the previous week's activity.
% (Simulated) Data summary:
%   - Scores of three groups; each group has assessment scores 
%     at three time points: pre, post, and one month
%   - Each group has N=100 subjects.
% Each group's score is saved as a csv file (ex. 'group1.csv')
% Each csv file will have 300 x 3 matrix. The three columns correspond to
% pre, post, and one month score of 100 subjects.

% Data is prepared by modifying what Devin originally prepared...
% preProperties = struct('means', [43, 50, 77], 'std', [5, 10, 8]);
% postProperties = struct('means', [80, 60, 88], 'std', [5, 25, 11]);
% oneMonthProperties = struct('means', [100, 70, 90], 'std', [10, 40, 10]);


%% Specify (figure) parameters
% All figures stem from a single "graphics object" otherwise known as a
% groot. This groot serves as a template for any figure you may make so
% changing specific properties of the template (e.g. font style) will make
% changes for all subsequent figures. 

% for a mostly complete list of defaults properties:
% https://undocumentedmatlab.com/articles/getting-default-hg-property-values/

% Below, I set the default properties of groot to the sizes and styles that
% fit my preference. 
set(groot,'defaultAxesFontName','Ariel')
set(groot,'defaultAxesFontSize',18)
set(groot,'defaultLineLineWidth',1)


%% Read data and prepare a table
% Here we wil prepare a 300 x 4 table. The first three columns will contain
% three scores (pre, post, one month) of 300 subjects.
% The last column will have group label ('Group1', 'Group2', and 'Group3')

% Define data characteristics
N_TIMES = 3;
N_GROUP = 3;
N_SUBJ = 100;
GROUPS = {'Group1', 'Group2', 'Group3'};
TIMELABELS = {'pre', 'post', 'onemonth'};

% Memory preallocation
groupScores = zeros(N_SUBJ*N_TIMES, N_TIMES);

% Prepare a label array
%
% >> help repelem
% **repelem** Replicate elements of an array.
% U = repelem(V,N), where V is a vector, returns a vector of repeated
% elements of V.
% - If N is a scalar, each element of V is repeated N times.
% - If N is a vector, element V(i) is repeated N(i) times. N must be the
%   same length as V.
groupLabels = repelem(GROUPS, N_SUBJ)';

for group_idx = 1:N_GROUP
    % Here rowidx is defining the range of rows that will be 'filled in'
    % It will be 1:100, 101:200, and 201:300.
    rowidx = (1 + N_SUBJ*(group_idx-1)):(group_idx*N_SUBJ);
    % readmatrix(FILENAME) creates a homogeneous array by reading from 
    % a file stored at FILENAME.
    groupScores(rowidx, 1:N_TIMES) = ...
        readmatrix(['group', num2str(group_idx), '.csv']);
end

% Convert an array to a table first using `array2table()`
groupTable = array2table(groupScores,...
    'VariableNames',TIMELABELS);

% and add a categorical variable using `categorical()`.
groupTable.group = categorical(groupLabels, GROUPS);

% Let's add a new column, subject, to assign identifiers for individual
% subjects.
% I will just randomly assign subject id - 'a%d' for subjects in group1,
% 'b%d' for those in group2, and 'c%d' for those in group3.
groupTable.subject = [arrayfun(@(x)['a', num2str(x)], 1:100, 'UniformOutput',false),...
    arrayfun(@(x)['b', num2str(x)], 1:100, 'UniformOutput', false),...
    arrayfun(@(x)['c', num2str(x)], 1:100, 'UniformOutput', false)]';


%% Statistical analysis: I. Calculate group summary statistics
% We may want to get the mean, standard deviation, median, and IQR of 
% each group's score at pre, post, and one-month time points.
% If `varfun` and the appropriate function handle are used together
varfun(@mean, groupTable, 'GroupingVariables', 'group');
% There's another function: `grpstats`.
%
% >>help grpstats
% **grpstats** - Summary statistics organized by group
% Syntax
%   tblstats = grpstats(tbl, groupvars)
%
% See a simple usecase below.
grpstats(groupTable, 'group');

% You can get other summary statistics - std? median or iqr?
grpstats(groupTable, 'group', 'std');
grpstats(groupTable, 'group', 'iqr');

% If you want to calculate the statistics for a subset of variables
grpstats(groupTable, 'group', 'median', 'DataVars',["pre", "post"]);

% Compare with the code using varfun:
varfun(@median, groupTable, 'GroupingVariables','group','InputVariables',["pre", "post"]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% EXERCISE - please calculate group median of 'post' and 'one-month' scores
% PROVIDE YOUR CODES HERE


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


%% Statistical analysis: II. One-way ANOVA
% While it is not appropriate, lets's consider the data to be
% not repeated measures.
% Also to make things simple, let's only look at group1 data.

% Then let's check if the three **time points** of group1 data
% are significantly different or not using one-way ANOVA.
subset1 = groupTable(groupTable.group == 'Group1', :);

% Running one-way ANOVA can be done in two different ways:
%   1) use `fitlm()` and `anova()` function. `fitlm()` specifes the model
%      structure and `anova()` prepares a table reporting statistics.
%      `fitlm()` function expects its input to be in the long format
%      (wide vs. long).
%   2) use `anova1()` function

% Wide data has a column for each variable. If it's a repeated measures
% design, then measurement at each timepoint will be stored in separate
% columns.

% Long data has a column for possible variable types and another column
% for the values of those types.

subset1Long = stack(subset1, 1:3,...
    'NewDataVariableName','scores','IndexVariableName','Time');
oneway = fitlm(subset1Long, 'scores~Time');
anova(oneway);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% EXERCISE - Let's run another one-way ANOVA on the score differences
% (post-pre) of the three groups.
% So we're asking if groups are significantly different in terms of
% pre-post change in score.
%
% 1. First prepare a dataset of score differences.
%    A simple way is to make a vector of score differences using
%    `groupTable` and bind it with the `group` column of the table.
scorediff = ...
diffTable = table(scorediff, groupTable.group,...
    'VariableNames', {'scorediff', 'group'});

% 2. Then run one-way ANOVA just showed above
oneway2 = ...
anova(oneway2)
% 2.1 - you can also use `anova1()` function, and this is somewhat
% 'recommended' if you're planning to do post-hoc multiple comparisons...
% You can use the function in different ways.
% 1) P = anova1(M) for a **matrix** M treats each column as a separate
%    group, and determines whether the population means of the columns
%    are equal. This requires you to transform diffTable to a matrix
%    of three columns
%    A little trick needed...
diffTable.sid = repmat([1:100]', 3, 1);
diffScoreMat = unstack(diffTable, 'scorediff', 'group');
diffScoreMat = table2array(diffScoreMat(:, 2:4));
% p = p-value of the factor
% t = table showing Sum of Squares, df, F and p-values
% st = a structure saving information about this ANOVA output.
% REPLACE '...' WITH THE RIGHT VARIABLE AND CHECK IF THE OUTPUT OF
% `anova1()` IS IDENTICAL TO WHAT YOU GENERATED USING `anova()`
[p, t, st] = anova1(...);
[c, m, h, gnames] = multcompare(st);
% 2) P = anova1(V, GROUP) groups elements in the vector V according to
%    values in the grouping variable GROUP. GROUP must be a categorical
%    variable, numeric vector, logical vector, string array, or cell
%    array of strings with one group name for each element of X.
%    (This, IMO, is a simple way to use `anova1()`)
% PLEASE COMPLETE THE FOLLOWING TWO LINES TO PREPARE 'V' AND 'GROUP'.
V = ...;
GROUP = ...;
[p, t, st] = anova1(V, GROUP);
[c, m, h, gnames] = multcompare(st);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


%% Statistical analysis: III. Mixed ANOVA
% Given that this data assume a repeated measures design,
% we can consider conducting repeated measures ANOVA.

% First specify the model structure.
% Data be prepared in the 'wide' format.

% groupTable has been prepared in the wide format.
groupTable;

% To run repeated measures ANOVA, first specify the model structure
rm = fitrm(groupTable, 'pre-onemonth ~ group',...
    'WithinDesign', [1,2,3]',...
    'WithinModel', 'orthogonalcontrasts');
rm

% Then use the function `ranova()` to report results in a table.
ranovatbl = ranova(rm);
ranovatbl

% ranovatbl does not display testing result for the between-group
% variable, 'group'. You need to use `anova()` to run ANOVA for
% between-subject effects in a repeated measures model.
anovatbl = anova(rm);
anovatbl

% Mauchly's test of sphericity - violated
% However, ranovatbl shows correction applied p-values as well:
%   - Greenhouse-Geisser (pValueGG)
%   - Huynh-Feldt (pValueHF)
%   - Lower-bound (pValueLB) 
mauchly(rm);

% With the model specification, you can plot
% the estimated marginal means based on the factor 'Time'
% and grouped by 'group'.
plotprofile(rm, 'Time', 'Group', 'group');

% You can use the model specification to plot individual data too
plot(rm, 'group', 'group');

% post-hoc analysis: do groups differ at each time point? 
multcompare(rm, 'group', 'By', 'Time', 'ComparisonType', 'bonferroni')

% post-hoc analysis 2: does each group 'change' between time points? We'll
% save this for later use. 
resultsTable = multcompare(rm, 'Time', 'By', 'group', 'ComparisonType', 'bonferroni');
resultsTable

%% Statistical analysis: IV. Linear mixed (effects) model
% Let's fit an LME model to the data with random intercepts for subjects.
% To fit a linear mixed (effects) model in MATLAB,
% you need data in the long format (as showcased in II)

groupTable.subject = categorical(groupTable.subject);

% Transform to long format
groupTableLong = stack(groupTable, 1:3,...
    'NewDataVariableName','scores','IndexVariableName','Time');

lme = fitlme(groupTableLong, 'scores ~ group * Time + (1|subject)');

% lme has many attributes (?) - plot the residuals to check if
% the normality assumption is met
lme.plotResiduals;

% and random effects - random effect should also be 'approximately'
% following N(0, 1)
hist(lme.randomEffects);

% No random effect linear model
lm = fitlm(groupTableLong, 'scores ~ group * Time');

% Plot Fitted vs. residuals
% There's heteroscedasticity - variance near the fitted value
% between 60 and 70 is greater than that at elsewhere.
F = fitted(lme);
R = residuals(lme);
plot(F, R, 'bx');

% There's a neat function - plot the same stuff, but grouped by
% the grouping variable: `gscatter()`
% Fit to group2 data may be problematic?
gscatter(F, R, groupTableLong.group)


%% Create initial figure 

f1 = figure('NumberTitle','off','Name','Effect of training Pre vs Post');
axes = gca();
hold on

ylabel({'Assessment';'score'})

% When setting the size of your figures, you can use the keyword
% 'Position' that takes [left, bottom, width, height]. Typically matlab
% defaults these values to pixels in order to ensure figures fit on any
% screen. When making posters, presentation, or manuscripts, you usually
% want your figure to be a specifc size. Here, I change the units and set
% the positon using centimeters. 
set(f1, 'Units', 'centimeters','Position', [2,2,25,18]);


%% Organize/Prepare Data

data = [groupTable.pre(groupTable.group == 'Group1'), ...
    groupTable.post(groupTable.group == 'Group1'), ...
    groupTable.onemonth(groupTable.group == 'Group1'), ...
    groupTable.pre(groupTable.group == 'Group2'), ...
    groupTable.post(groupTable.group == 'Group2'),...
    groupTable.onemonth(groupTable.group == 'Group2'),...     
    groupTable.pre(groupTable.group == 'Group3'), ...
    groupTable.post(groupTable.group == 'Group3'),...
    groupTable.onemonth(groupTable.group == 'Group3')];

N = length(groupTable.pre(groupTable.group == 'Group1')); % number of participants in each group

dataLabels = ["Group1 Pre", "Group1 Post", "Group1 One Month",...
    "Group2 Pre", "Group2 Post", "Group2 One Month", ...
    "Group3 Pre", "Group3 Post", "Group3 One Month"];

dark_red  = "#C70808";
dark_blue  = "#23537F";
light_orange  = "#FD8B0B";

dataColors = [dark_red, light_orange, dark_blue,...
    dark_red, light_orange, dark_blue,...
    dark_red, light_orange, dark_blue];

%% Plot boxchart and raw data 

% Plotting raw data on boxcharts is an easy way to increase the transparaency of
% your science and interpretability of your figures. One common issue is
% raw data tends to overlap. To avoid this, we can slightly jitter our
% data.
jitterWidth = .25;

% We also want to connect our the pre and post data points for each group.
% Because we're going to jitter the x coordinate of our data points, we
% need to store the new x values. 
storedData = struct('x', NaN(N, length(dataLabels)), 'y', NaN(N, length(dataLabels)));

% for loop to index between groups.
for i_idx = 1:length(dataLabels) % 1:Total number of datasets
    
    yData = data(:,i_idx);
    xData = ones(1,length(yData))*i_idx;
    
    % alter the xData with the specified jitter
    xData_withJitter = (i_idx - jitterWidth) + 2*(jitterWidth)*rand(1,length(yData));

    storedData.x(:,i_idx) = xData_withJitter;
    storedData.y(:,i_idx)  = yData;
    
    % plot the box chart
    boxchart(axes,xData, yData, 'boxfacecolor', dataColors(i_idx), 'markerstyle', 'none', 'boxwidth', .95) ;
    
    % plot the raw data as a scatter plot
    scatter(axes, xData_withJitter,yData,8, MarkerFaceColor=dataColors(i_idx), MarkerEdgeColor='black');

end

%% Connect raw data points

% specify the color used for the lines
grey = '#808080';

% This time we want to add significance markers to our plots for within group comparisons.
% To do this, we'll need to find the correct pvalue for a specifc pairing
% of time periods for each group. The pvalues we want to grab are in the
% 'resultsTable' created eariler in the code. 

% this variable will help us keep track of the first time period (pre, post, one month)
% we want to compare within a given group. This will change within the for
% loop.
timeOneID = 0;

% the first for loop indexes between groups
for k_idx = [1, 2, 4, 5, 7, 8] % Here, the for loop indexes through each item of the given array
    
    groupID = ceil(k_idx/3); % obtain the ID of the group for between group comparisons
    timeOneID = timeOneID + 1; % define what the first time period is (1 = pre, 2 = post)
    timeTwoID = timeOneID+1; %  define the second time period (2 = post, 3 = one month)

    % Below is a function that finds the correct p value given the table,
    % group ID, and what two time periods you want to compare. Right click
    % the function and click "Open" for more details. 
    pVal = FindPValueFromTable(resultsTable, groupID, timeOneID,timeTwoID);
    
    % Below is another function that plots a significance marker given the
    % axes of the figure, the index of the first and second groups, the y
    % Position of the marker, and the height of the marker.
    PlotSignificantDifference(axes, k_idx, k_idx+1, 225, 5, pVal);

    if k_idx == 1 || k_idx == 4 || k_idx == 7 % check for the pre time period of each group

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
% EXERCISE - Using the function above, obtain the correct pvalue to compare
% the pre and one month periods.

        pVal = 1;
        % Comment out the line above and write your answer here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Here we plot the significance marker for the pre and one month
        % comparisons. We use the previous function in a slightly different way. 
        % Due to the 'input parser' within the function,
        % we cant set optional arguments like 'symbol' and 'alpha'. 
        % See function for more details.
        PlotSignificantDifference(axes, k_idx, k_idx+2, 250, 5, pVal, ...
        symbol = '*', ...
        alpha = 0.05);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    % If the current k_idx is in the post index of one of the groups, reset
    % the timeOneId so it never goes beyond 2
    if k_idx == 2 || k_idx == 5
        timeOneID = 0;
    end
    
    % the second for loop indexes each data point (may need to be fixed)
    for j_idx = 1:N %1:N (N = number of participants)

        % plot line connecting a single dataset from the pre and post of
        % each group. Assigning the plot to a varaible allows us to change
        % the properties of that plot later. 

        X1 = storedData.x(j_idx,k_idx);
        X2 = storedData.x(j_idx,k_idx+1);
        Y1 = storedData.y(j_idx,k_idx);
        Y2 = storedData.y(j_idx,k_idx+1);

        line = plot(axes, ... 
            [X1, X2], ... % [groupN_pre_x, groupN_post_x]
            [Y1, Y2],... % [groupN_pre_y groupN_post_y]
            color = grey);
        
        % Change the alpha level of the line
        set(line, 'Color', [line.Color, 0.1])
        
        % optional code to move the line to the back of the figure. 
        % BEWARE: this may slow down the code. 
%          uistack(line, "bottom")
    end
end

% rename the xticks
xticks(1:9); xticklabels(dataLabels);
