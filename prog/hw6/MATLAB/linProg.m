%% read inputs and outputs for units from excel files
I = xlsread('../data/inputs.xls');
O = xlsread('../data/outputs.xls');


%% prepare matrice for linear programming
[m n1] = size(I);
[m n2] = size(O);


% x is [u1; u2; ...; un2; v1; v2; ... ; vn1]
%% question 1.
a_d = [zeros(m, n2), I];
b_d = [O, zeros(m, n1)];
c_d = [O, - I];

% placeholder of x
x = zeros(m, n1 + n2);

for i = 1 : m
    z = linprog(a_d(i, :), c_d, zeros(m, 1), b_d(i, :), 1, zeros(n1 + n2, 1));
    x(i, :) = z';
end

% resulting inputs and ouputs
res_1 = x .* [O, I];

% check on constrains
numer = sum(res_1(:, 1 : n2), 2)
denom = sum(res_1(:, (n2 + 1) : end), 2)

% the maximum ratio
numer ./ denom


%% question 2.

% placeholder of x
x = zeros(m, n1 + n2);

for i = 1 : m
    z = linprog(- c_d(i, :), c_d, zeros(m, 1), a_d(i, :), 1, zeros(n1 + n2, 1));
    x(i, :) = z';
end

% resulting inputs and ouputs
res_2 = x .* [O, I];

% check on constrains
inSum = sum(res_2(:, (n2 + 1) : end), 2)

% the maximum difference
outSum = sum(res_2(:, 1 : n2), 2)
outSum - inSum                          % == diag(c_d * x')

% efficiency
outSum ./ inSum
