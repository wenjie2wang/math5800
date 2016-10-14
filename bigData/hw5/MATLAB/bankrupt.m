%% ================== Reset the workspace ===================
clear all; close all; clc;
% ================== No regularization =====================
[data,txt,raw] = xlsread('bankruptcy.xls','Sheet1');
X1 = data(:,1:12);
X = normalize(X1);
y = data(:,13);
[m,n] = size(X);
X = [ones(m,1), X];
theta = zeros(n+1,1);

%% Optimization using fminunc
options = optimset('GradObj', 'on', 'MaxIter', 100);
[theta,cost] = fminunc(@(t)(computeCost(t,X,y)),theta,options);

% Accuracy with training set
pred = sigmoid(X*theta) >= 0.5;
fprintf('Accuracy: %f\n', mean(double(pred==y))*100);

%% ============= Now use regularization  ====================
Reload the data
[data,txt,raw] = xlsread('bankruptcy.xls','Sheet1');
X = data(:,1:12);
X = normalize(X);
y = data(:,13);

% Mapping to higher dimensional space
X = mapping(X,2);
theta = zeros(size(X,2),1);
lambda = 0.01;

% Optimization using fminunc
options = optimset('GradObj','on','MaxIter',50);
[theta,cost] = fminunc(@(t)(computeCost(t,X,y,lambda)),theta,options);

% Compute accuracy on our training set
pred = sigmoid(X*theta) >= 0.5;
fprintf('Accuracy: %f\n', mean(double(pred==y))*100);