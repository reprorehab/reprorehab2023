% A `char`acter array is a sequence of characters.
% Use single quotes to generate one.
charr = 'This is a character array';

% Therefore, the length of the array is equal to
% the number of characters in the array.
% So this returns 25
length(charr)

% You can parse it by indicating the indices.
charr(10:19)

% If you use the square bracket to make an array of char arrays,
% you will end up having one array with the characters merged.
chararray = [charr, 'See What Happens!'];
chararray

% Rather, you would want to create a `cell` array of char arrays
chcellarray = {charr, 'Now See What Happens!'};
chcellarray


% A `string` array is a container for pieces of text.
% Use double quotes to generate this.
% The length of a string array, regardless of how many characters
% are in, is 1.
strarr = "This is a string array";
length(strarr)

% Each string cannot be 'parsed'. You will see an error message here.
strarr(1:4)

% You can use the square bracket to make an array of string arrays.
strarray = [strarr, "Hello, World!", "MATLAB is FUN!"];

% You can use the curly bracket to make a cell array of string arrays.
strcellarray = {strarr, "Hello, World!", "MATLAB is FUN!"};
strcellarray


% Conversion between the two is fairly simple. `char` function will
% convert a string array to a character array.
char(strarr)
% convertStringsToChars does the same job.
convertStringsToChars(strarr)
% char to string? no problemo.
string(charr)
% convertCharsToStrings
convertCharsToStrings(charr)
% To a string array of string arrays?
convertStringsToChars(strarray)
% and vice versa
convertCharsToStrings(chcellarray)