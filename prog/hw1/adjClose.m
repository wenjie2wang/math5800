function y = adjClose(fromMonth, fromDay, fromYear, ...
                      toMonth, toDay, toYear, period)
    % function extracting adjusted closing price for the given
    % symbols read from *symbols.xls* over a specified time period.
    % Authors: Wenjie Wang and Hao Li

    % read symbols from excel file 'symbols.xls'
    symbols = readtable('symbols.xls');
    symbols = symbols{:, 1};
    % s = symbols: all (capitalized) char cell array
    s = cellstr(upper(symbols));

    % a = fromMonth - 1: (integer) ranging from 0 to 11
    a = num2str(fromMonth - 1);
    % b = fromDay: two digits
    b = sprintf('%2d', int64(fromDay));
    % c = fromYear
    c = sprintf('%4d', int64(fromYear));
    % d = toMonth - 1: (integer) ranging from 0 to 11
    d = num2str(toMonth - 1);
    % e = toDay: two digits
    e = sprintf('%2d', int64(toDay));
    % f = toYear
    f = sprintf('%4d', int64(toYear));

    gs = {'d', 'm', 'y'};
    if ~ischar(period) || length(period) > 1 || ~any(strncmp(period, gs, 1))
        error('period must be d for daily, m for monthly, or y for yearly.')
    end
    g = period;

    nS = length(s);
    yy = [];
    % loop over each symbol
    for i = 1 : nS
        yy(:, i) = oneAdjClose(s{i}, a, b, c, d, e, f, g);
    end
    y = array2table(yy, 'VariableNames', s);

end


function yy = oneAdjClose(ss, a, b, c, d, e, f, g)
    % function to process one symbol
    % Authors: Wenjie Wang and Hao Li

    % url for one symbol
    url = ['http://ichart.finance.yahoo.com/table.csv?' ...
           's=' ss '&' ...
           'd=' d '&' ...
           'e=' e '&' ...
           'f=' f '&' ...
           'g=' g '&' ...
           'a=' a '&' ...
           'b=' b '&' ...
           'c=' c '&' ...
           'ignore=.csv'];
    x = urlread(url);
    data = strsplit(x, '\n');
    data = data';
    % eliminate the last empty line
    nRow = length(data) - 1;
    for i = 1 : nRow
        dat(i, :) = strsplit(sprintf('%s', char(data(i, :)), ','), ',');
    end
    dim = size(dat);
    % remove last empty column
    dat = dat(:, 1 : (dim(1, 2) - 1));
    colNames = dat(1, :);
    % remove variable names
    dat = dat(2 : dim(1, 1), :);
    % index of the adjusted closing price
    idx = cellfun(@(x) strcmp(x, 'Adj Close'), colNames);
    % rename for table
    colNames{1, idx} = 'AdjClose';
    tab = cell2table(dat);
    tab.Properties.VariableNames = colNames;
    yy = tab.AdjClose;
    yy = cellfun(@(x) str2num(x), yy);
end