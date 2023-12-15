% A simple example of creating a json metadata file
% For more detail, refer to https://www.mathworks.com/help/matlab/ref/jsonencode.html

% Create a struct
sub_jin = struct;
% Assign values to the fields
sub_jin.assigned_condition = "Control";
sub_jin.gender = "M";
sub_jin.age = 34;
sub_jin.handedness = "Left";
subj_jin.caffeine_intake = 300;

% jsonencode is the function that will help convert
% a struct to readable JSON.
encoded = jsonencode(sub_jin);
% open a file and write to it
fname = fopen('sub_jin-metadata.json', 'w');
fprintf(fname, encoded);
% close the file
fclose(fname);