clear;

% Authors: Wenjie Wang and Hao Li

% call function to extract adjusted closing price for symbols
% daily price from 4/13/2009 to 1/28/2010
out = adjClose(4, 13, 2009, 1, 28, 2010, 'd');

% define output file name
outFile = 'adjClose.xls';

% remove output file if it exists
if exist(outFile) == 2
    system(['rm -rf ' outFile]);
end
% save output to external excel file
writetable(out, outFile);