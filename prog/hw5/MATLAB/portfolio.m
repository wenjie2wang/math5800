%% clean up the workspace
clear all; clc;


%% generate artificial returns data
rng(1216);                              % set random seed
ns = 60;                                % number of scenarios
na = 10;                                % number of assets
retn = 0.005 + randn(ns, na) * 0.015;
mu = mean(retn);
Q = cov(retn);


%% question 1. tangency portfolio and efficient frontier
rf = 0.0001;                            % risk-free constant
mu2 = mu - rf;
c = zeros(1, na);
Aeq = mu2;
beq = 1;

% solution
w = quadprog(Q, c, [], [], Aeq, beq);
w_tan = w / sum(w);                     % re-scale

% check constraints
sum(w_tan)

% expected return and variance from tangency portfolio
retn_tan = mu * w_tan;
se_tan = sqrt(w_tan' * Q * w_tan);

% minimal variance portfolio
w_min = quadprog(Q, c, [], [], ones(1, na), 1);
retn_min = mu * w_min;
se_min = sqrt(w_min' * Q * w_min);
sum(w_min)                              % quick check on constraint

% construct efficient frontier from tangency and minimal variance portfolio
retnVec = [retn_min, retn_tan];
seVec = [se_min, se_tan];
varMat = diag(seVec .^ 2);
varMat(1, 2) = w_min' * Q * w_tan;
varMat(2, 1) = varMat(1, 2);
alpha = linspace(1, - 1, 50);
tmpMat = [alpha', (1 - alpha)'];
retn_eff = tmpMat * retnVec';
se_eff = sqrt(diag(tmpMat * varMat * tmpMat'));

% plot it out
plot(se_eff, retn_eff, 'k-'); hold on;
refline((retn_tan - rf) / se_tan, rf);
plot(se_min, retn_min, 'r.');
plot(se_tan, retn_tan, 'b.');
legend('Efficient Frontier', 'Captial Market Line (CML)', 'Minimal Portfolio', ...
       'Tangency Portfolio', 'Location', 'northwest')
xlabel('Volatility');
ylabel('Expected portfolio return');
hold off;
print('figure_a2', '-dpng');


%% question 2. trade-off portfolio
tuning = 1e3;
w_trade = quadprog(tuning * Q, - 2 * mu, [], [], ones(1, na), 1);
retn_trade = mu * w_trade;
se_trade = sqrt(w_trade' * Q * w_trade);
sum(w_trade)                            % quick check on constraint

% plot it out
plot(se_eff, retn_eff, 'k-'); hold on;
plot(se_trade, retn_trade, 'g.');
legend('Efficient Frontier', 'Trade-off Portfolio', 'Location', 'northwest')
xlabel('Volatility');
ylabel('Expected portfolio return');
hold off;
print('figure_b2', '-dpng');


%% question 3. tracking portfolio
% take the resulting trade-off portfolio as the benchmark portfolio
wsup = 0.15;
winf = 0;
A = [eye(na); - eye(na)];
b = [repmat(wsup, na, 1); repmat(- winf, na, 1)];
Aeq = ones(1, na);
beq = 1;
w_track = quadprog(Q, - w_trade' * Q, A, b, Aeq, beq);
retn_track = mu * w_track;
se_track = sqrt(w_track' * Q * w_track);
sum(w_track)                            % quick check on constraint

% plot it out
plot(se_eff, retn_eff, 'k-'); hold on;
plot(se_trade, retn_trade, 'g.');
plot(se_track, retn_track, 'm.');
legend('Efficient Frontier', 'Benchmark Portfolio', 'Tracking Portfolio', ...
       'Location', 'northwest')
xlabel('Volatility');
ylabel('Expected portfolio return');
hold off;
print('figure_c2', '-dpng');
