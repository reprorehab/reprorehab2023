%% Tips for S1_Simulate_Adaptation_Data.m
% tip 1: a little more elegant way to 'number' your file name
N_Participants = 16;
for Participant_Num = 1:N_Participants
    % T = num2str(X, FORMAT) uses the format specifier FORMAT.
    % "%f" is the FORMAT to indicate double (floating point number)
    % `Participant_Num` is a double.
    % You can specify how many digits you will display.
    % If you want to specify the decimal places, you use:
    %   %.2f (ex. 13.00) or %.4f (ex. 13.0000)
    % If you want to pad zeros in front of numbers, you use:
    %   %03.f (ex. 013) or %05.f (ex. 00013)
    disp(['20220912_S', num2str(Participant_Num, '%02.f')])
end

% tip 2: instead of keep moving to a subfolder, save the file,
% and coming back to the original folder, you can specify the
% filepath using `fullfile` function and save files in the
% current working directory.
%
% In Dr. Finley's code:
%  51|  mkdir(['20220912_S0' num2str(Participant_Num)])
%  52|  cd(['20220912_S0' num2str(Participant_Num)])
%       ...
% 115|  if Participant_Num < 10
% 116|      writematrix(SLA, ...
% 117|          ['20220912_S0' num2str(Participant_Num) '_SLA.csv'])
%       ...
% 123|  cd(Home)
%
% Instead of working like this, you can try something like this.
%  51|  dirpath = ['20220912_S num2str(Participant_Num, '%02.f')];
%  52|  mkdir(dirpath)
%       ...
% 115|  writematrix(SLA, ...
% 116|      fullfile(dirpath, [dirpath '_SLA.csv']))
%
% Now you don't need `cd(Home)` command, because you're not leaving
% your current working directory. Also do notice that you don't need
% if-else statements, because specifying the number format is replacing
% that feature.
% (fullfile is used in S2_Combine_Adaptation_Data.m)

% tip 3: think about how a parameter value is used within a function.
% In lines 36, `True_Parameters` is defined as a 16-by-4 array.
% It is later updatedted inside a for-loop (line 93).
% The loop iterates from 1 to `N_Participants`, which is the parameter
% value you provide. By now you learned that in order to run a function
% that requires a parameter value, you need to run like this:
%
% >> S1_Simulate_Adaptation_Data(N_Participants)
%
% If N_Participants=20, what happens?
% You don't see an error. MATLAB quickly adds extra 4 rows
% What if N_Participants=100? 1,000,000? Would the process still be quick?
% Let's see the example here:
n_iter = 1000000;   % number of iteration
tic     % tic/toc is a useful function to measure processing time
x = zeros(1);
for k = 2:n_iter
    x(k) = x(k-1) + 5;
end
toc
% On my computer, this iteration takes near 0.3 seconds.
% If you make the size of x equal to the number of iterations,
% it will take less.
tic
x = zeros(1,n_iter);
for k=2:n_iter
    x(k) = x(k-1) + 5;
end
toc
% Now the elapsed time reduces by about 1/10.
% If you're interested in learning more, please refer to:
% https://www.mathworks.com/help/matlab/matlab_prog/preallocating-arrays.html
%
% So if `N_Participants` is LARGE, it may take a while for the function to
% finish. The key is, you better define the dimension of `True_Parameters`
% according to the number of iteration, which is again, N_Participants.

%% Tips for S3_Summarize_Adaptation_Data.m
% In line 15, Dr. Finley uses `function handle`
% 15|   Double_Exp_Model = @(Coeff,x)Coeff(1)*exp(-Coeff(2)*x(:,1) + ...
%
% A function handle is a [variable] that allows you to
% invoke a function indirectly. So here `Double_Exp_Model` is a variable,
% just as much as `aa` in `aa=13;` is a variable.
%
% You can create a function handle for a defined function. For example,
ones
% is a function that generates an N-by-N Ones array. If no input argument
% is provided, N=1
% You can create a function handle like
fh = @ones;
% and then use the function handle like
result = fh(4)
% Arguments you provide are the same as those for the original function:
result2 = fh(4,3)

% Similar to the case introduced in the video, you often want to create
% your own function within an analysis script and use it later.
% Typical uses of function handles include:
%   1) passing a function to another function (introduced in the video)
%   2) specifying callback functions
%   3) constructing handles to functions defined inline instead of stored in a program file
%   4) calling local functions outside the main function
%
% The third use case describes a situation like this -
% suppose there's no MATLAB default function that does what you want, so you want to
% define a function within your analysis script.
% MATLAB does NOT allow you to define functions in that way - you need to have a separate
% mfile with its title the same as the name of the function.
% Try running the lines below. It will tell you that functions can only be created as
% `local` or `nested` functions in code files.
function z = SumOfSquares(x,y)
z = x.^2 + y.^2;
end
% So you can't create a function: SumOfSquares this way.
% Rather, you should have a separate script (SumOfSquares.m).
SumOfSquares(1:5, 3:7)
% If you want to create this function inline (inside your script),
fh2 = @(x,y)x.^2 + y.^2;
% Then fh2 will work the same as SumOfSquares.
fh2(1:5, 3:7)

% Let's check S3_Summarize_Adaptation_Data.m again.
% The function handle `Double_Exp_Model` takes "Coeff" and "x"
% as the two arguments. "Coeff" is an array, as inside the definition
% of the function handle, "Coeff" is indexed.
% You can expect that once this function handle is created,
% later you use it like:
%   Double_Exp_Model([0.2, 0.4, 0.7, -0.1], rand(10, 1))
% If you don't trust me, please run lines below ;)
Double_Exp_Model = @(Coeff,x)Coeff(1)*exp(-Coeff(2)*x(:,1)) + ...
    Coeff(3)*exp(-Coeff(4)*x(:,1));

Double_Exp_Model([0.2, 0.4, 0.7, -0.1], rand(10, 1))

% However, in Dr.Finley's code, this is not exactly how the function
% handle is used.
% That's becaluse of the requirement of the function `fitnlm`.
% You can type the following to learn more about fitnlm:
%   help fitnlm
% fitnlm can be used in many different forms. The way Dr.Finley used
% this function is the following:
%   NLM = fitnlm(X,Y,MODELFUN,BETA0)
% where X is the predictor variable(s), Y is the response variable,
% MODELFUN is the model to fit and BETA0 is an array of coefficients'
% initial values.
% If you read carefully, you can see that MODELFUN is one of the two
% formats: 1) a function, specified using @, that accepts two arguments,
% a coefficient vector and an array of predictor values or 2) a text string,
% such as 'y~b0*exp(-b1*X)+b2*exp(-b3*X)'.
%
% Can you now see that he used the first form of MODELFUN in his code?
% If not, scoll up a bit and see the definition of `Double_Exp_Model`
% and look for the symbol `@`. Then look for the location of the function
% handle from the line below:
%   Data(Participant_Num).Model = fitnlm((1:numel(Data(Participant_Num).SLA))',...
%       Data(Participant_Num).SLA', Double_Exp_Model, Coeff_Init);
%
% Lastly, I don't think it's necessary to explain, but just in case -
% why did he change the order of the estimated coefficients?
% That's because he's trying to save the estimates in the order he specified
% when he created the table `Coefficients_All`.
% The order is A_slow, B_slow, A_fast, B_fast.
% Let's see how the double exponential model is specified:
% (btw, his original comment has a typo - the second B_f is A_s
%   SLA = A_f*e^{-B_f*n} + A_s*e^{-B_s*n}
%
% So you can see that the first term and the second term of the right side
% are identical in structure. When estimating coefficients, MATLAB does NOT
% know if the first coefficient estimated is A_f or A_s. It will just do its
% best to find the coefficients with which the model fits best to the data.
% That's why Dr.F tells MATLAB that if the second coefficient estimate is bigger
% than the fourth coefficient, shuffle coefficients to be in the right order.