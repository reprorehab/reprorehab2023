% This script compiles data from the 50 participants collected as part of
% the study described in Lencioni et al., 2019 and also recreates most of
% Figure 3 from the same manuscript.
%
% James M. Finley 2022/10/29
%
% Reformatted and commented additionally by Jinseok Oh [JO] 2023/10/30
%
% JO: Please download the zip file and extract it before working
%     with the code. Also, please address both [Q]uestions and [R]equests.

% Clear console and workspace and close open figure windows
clc
clear
close all

% Create variable, Home, to store the location of the home directory. This
% is the directory where our scripts are stored.
% Home = cd;
%
% JO: Instead of jumping from one directory to another,
%     define the path to the directory where .mat files are stored
%     and later concatenate this path with a .mat file name and provide
%     it to `fullfile`.

%% Q0.Tell MATLAB which folder to look for---------------------------------
% Please define the variable `dirpath` by providing the path
% to the correct directory. An example can be:
% dirpath = 'C:\Users\joh\Downloads\All_Subjects';
dirpath = 

%% Memory preallocation related job----------------------------------------
% Preallocate space to store the average joint angle trajectories for each
% partcipant. Note that there are 12 joints angles, each is
% time-normalized to 101 points, and we have data from 50 participants.
% Avg_Joint_Angles_Walking = zeros(12,101,50);
% Avg_Joint_Angles_HeelWalking = zeros(12,101,50);
% Avg_Joint_Angles_ToeWalking = zeros(12,101,50);
% Avg_Joint_Angles_Ascend = zeros(12,101,50);
% Avg_Joint_Angles_Descend = zeros(12,101,50);

% JO: The original code prepares five separate matrix arrays. 
%     We can practice a different approach - making a structure
%     and generate a `field` for a task.
%     Generating fields and assigning a zero matrix is a
%     repetitive job that can be done in a loop, so let's also
%     write a for-loop.
%     `initmat` is the initial zero matrix that will be
%     pre-allocated.
initmat = zeros(12, 101, 50);
% JO: These names will be used CONSISTENTLY
STUDYTASK = ["Walking", "HeelWalking", "ToeWalking", "Ascend", "Descend"];
% JO: Prepare a structure
Avg_Joint_Angles = struct();

%% Q1. Write a for loop to generate fields of a struct---------------------
% Please write a for-loop whose total number of iteration will
% be identical to the length of the string array: STUDYTASK.
% Inside the loop, you will
%   1) generate fields whose names are prepared in the STUDYTASK array
%   2) assign initmat to each field
% The two tasks can be done in a SINGLE line of code.
for
    % JO: 1) Generate/access a field using the dot operator.
    %        Call the name of the field immediately after
    %        the dot as described below:
    %
    %        >> Avg_Joint_Angles.Walking = initmat
    %        >> Avg_Joint_Angles.Walking   % This will return initmat
    %
    %     2) Same can be done by calling the "string" or 
    %        'character' of the field name wrapped inside
    %        parentheses as described below:
    %
    %        >> Avg_Joint_Angles.('Walking') = initmat
    %     
end

%% Prepare a figure--------------------------------------------------------
% Move to the directory where the data are stored
% cd('All_Subjects')

% Open figure window, remove figure number title, and give figure an
% informative name
f1 = figure;
set(f1,'NumberTitle','off','Name','Manuscript Figure 3')

%--------------------------------------------------------------------------
% Update the values of the looping variable to make sure that the data from
% each of the 50 participants are loaded. 
%--------------------------------------------------------------------------

%% Nested for loops--------------------------------------------------------
for Subj = 1:50

    % Load each participant's data
    % if Subj < 10
    %     Filename = ['Subject0' num2str(Subj) '.mat'];
    % else
    %     Filename = ['Subject' num2str(Subj) '.mat'];
    % end
    %----------------------------------------------------------------------
    % Q2. Please use the trick I mentioned in matlab_tips.m to
    %     replace the if-else-end code block commented above with a 
    %     SINGLE line of code.
    Filename = 


    %----------------------------------------------------------------------
    %-------------- Insert Command to Load Participant's Data -------------
    %----------------------------------------------------------------------

    % Initialze variables to store joint angle trajectories for each
    % partcipant. Since we do not know how many trials of each task were
    % completed by each participant, we initialize these variables as empty
    % arrays that will grow as we loop through the participant's data.

    % Joint_Angles_Walking = [];
    % Joint_Angles_HeelWalking = [];
    % Joint_Angles_ToeWalking = [];
    % Joint_Angles_Ascend = [];
    % Joint_Angles_Descend = [];

    % JO: Just as we created a single structure for the average joint 
    %     angles, we will have one structure for the subject-specific joint 
    %     angles. 
    
    %----------------------------------------------------------------------
    % Q3. Please create a structure named `Sub_Joint_Angles`.
    Sub_Joint_Angles =
    

    %----------------------------------------------------------------------
    % Q4. Please write a for-loop to generate fields whose names
    %     are listed in STUDYTASK. Each field will have an empty
    %     array as its value.
    for 
        
    end


    %----------------------------------------------------------------------
    % Write a for loop to cycle through each trial for the current
    % participant. Make the name of the looping variable 'Trial_Num.'
    % Within your for loop, create a variable called 'Task' that stores the
    % name of task that the participant performed during the current trial.
    % This name can be extracted directly from the participant's data
    % structure.
    %----------------------------------------------------------------------
    
    for 
        %------------------------------------------------------------------
        % Additional [R]equests of JO
        % R1. Please use `strtrim()` or `strip()` to strip whitespace
        %     when storing the name of task to the variable `Task`.
        %     This is in general a good practice, because people
        %     sometimes unintentionally put white spaces when they
        %     record string values - this example dataset added
        %     trailing whitespace purposefully, to make a 12-by-9
        %     `char` array...
        Task =

        %------------------------------------------------------------------
        % R2. Two original tasks are labeled 'StepUp' and 'StepDown'.
        %     Can you please replace 'StepUp' with 'Ascend' and
        %     'StepDown' with 'Descend' and store those replacements
        %     to the variable `Task`?
        %     You can use `contains()`, or `strcmp()`.
        %     You may want to use -if-elseif-end syntax.
        if
            ...
        elseif
            ...
        end

        %------------------------------------------------------------------
        % R3. Please complete the condition for the if statement
        %     so that ONLY the rows which have "RX" as the value of 
        %     field `Foot` are included in the analysis.
        if
            % JO: Instead of using switch, we will make use of the
            %     structure we created (Sub_Joint_Angles).
            
            %--------------------------------------------------------------
            % Q5. Please save the trajectories of the 12 joint angles
            %     (field 'Ang': 12-by-101 `double` array)
            %     to a variable named `filldata`.
            filldata = 

            % JO: I recommend understanding how `cat()` works.
            %     cat(DIM,A,B) concatenates the arrays A and B along
            %     the dimension DIM. Try the following lines to see
            %     what each value of DIM (1,2,or 3 - you would not need
            %     a number greater than 3).
            %
            %     >> arr1 = [1,2,3]; arr2 = [4,5,6];
            %     >> cat(1, arr1, arr2)
            %     >> cat(2, arr1, arr2)
            %     >> cat(3, arr1, arr2)

            %--------------------------------------------------------------
            % Q6. Please update the field of Sub_Joint_Angles whose name
            %     matches the value of `Task` using `cat()` and filldata.
            %     Hints for Q1 will help you here.
            

            % Plot ankle angle
            % JO: I replaced `Panels(1)` argument in the original code
            %     with `find(strcmp(...)). Can you see how this can
            %     give you the right index?
            %
            %     >> help strcmp
            %     TF = strcmp(S,A) compares S to each element of array A,
            %     where S is a character vector, a string scalar, or a cell
            %     array with one element, and A is a string array or a cell
            %     array of character vectors. **strcmp** returns TF, a
            %     logical array that is the same size as A and contains
            %     logical 1 (true) for those elements of A that are a
            %     match, and logical 0 (false) for those elements that are
            %     not. TF = strcmp(A, S) returns the same result.
            %
            %     Here I used strcmp(A, S), because STUDYTASK is a string
            %     array (line 44) and Task is a character vector.
            %     ('Walking', 'HeelWalking', etc.)
            %     The output of `strcmp(STUDYTASK, Task)` will be a
            %     numeric vector of four 0's and single 1. The location of
            %     1 depends on the value of `Task`. For example, if it is
            %     'Walking', then the vector will be [1 0 0 0 0].
            %
            %     >> help find
            %     I = find(X) returns the linear indices corresponding to
            %     the nonzero entries of the array X. X may be a logical
            %     expression.
            %
            %     Then `find([1 0 0 0 0])` will return 1. What about
            %     `find([0 0 1 0 0])`? Are you convinced that the line
            %     below will place a plot in the FIRST ROW of a figure
            %     containing 15 plots?
            subplot(3, 5, find(strcmp(STUDYTASK, Task)))
            
            % JO: Dr. Finley uses specific numbers as indices: 10, 7, 4
            %     We will go and search for each index.

            %--------------------------------------------------------------
            % Q7. Please convert the 'AngVarName' field of the loaded
            %     structure to a cell array for easy indexing using
            %     `cellstr()` and store the cell array as `angNamesInCell`.
            angNamesInCell =
            
            % JO: If you run the following line, ankleidx will save
            %     logical values (0: false, 1: true)
            %     ankleidx is [0 0 0 0 0 0 0 0 0 1 0 0]'.
            ankleidx = strcmp('AnkleFlx', angNamesInCell);
            % JO: A logical array can directly be used for indexing.
            plot(s.Data(Trial_Num).Ang(ankleidx, :), 'b'), hold on
            xlabel('% Task Duration')
            ylabel('Ankle [deg] extension & flexion')
            % JO: Give a title different from `Task` for
            %     Task=='Ascend' OR 'Descend'
            if strcmp(Task, 'Ascend')
                title('Step Ascending')
            elseif strcmp(Task, 'Descend')
                title('Step Descending')
            else
                title(Task)
            end

            % JO: `length(STUDYTASK)+find(...)`: second row of 5 plots
            subplot(3, 5, length(STUDYTASK)+find(strcmp(STUDYTASK, Task)))
            kneeidx = strcmp('KneeFlx', angNamesInCell);
            plot(s.Data(Trial_Num).Ang(kneeidx, :), 'k'), hold on
            xlabel('% Task Duration')
            ylabel('Knee [deg] extension & flexion')

            % JO: `2*length(STUDYTASK)+find(...)`: third row of 5 plots
            subplot(3, 5, 2*length(STUDYTASK)+find(strcmp(STUDYTASK, Task)))
            kneeidx = strcmp('HipFlx', angNamesInCell);
            plot(s.Data(Trial_Num).Ang(kneeidx, :), 'r'), hold on
            xlabel('% Task Duration')
            ylabel('Hip [deg] extension & flexion')

        end
    end

    % Store average joint angle trajectories for each participant. This
    % section of code is a bit clunky as not all participants perform all
    % tasks. As a result, we use the if-else-end construction to save a set
    % of NaN values for trials that the current subject didn't complete.
    
    %----------------------------------------------------------------------
    % R4. Please complete the for-loop below. 
    %     The purpose of this loop is to store the mean of each subject's
    %     task specific joint angle trajectories to 
    %     the `Avg_Joint_Angles` struct.
    for ii = 
        if ~isempty(Sub_Joint_Angles.(STUDYTASK(ii)))

        else
             = nan(12, 101);
        end
    end
end

%% Make a field to store metadata: names of the joints---------------------
% JO: Have a metadata field to store the names of the joints.
Avg_Joint_Angles.Ang = angNamesInCell;

% ------------------------------------------------------------------------
% Save the variables containing the average joint angles for the respective
% tasks to a file called "Avg_Joint_Ankles
% R5. Please save the entire structure `Avg_Joint_Angles` as a .mat file.
% ------------------------------------------------------------------------
save(...)