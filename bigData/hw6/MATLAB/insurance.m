%% ================== Reset the workspace ===================
clear all;close all;clc;

%% ================== Setting up ===================
input_num  = 21;
hidden_num = 100;
label_num = 2; % 10 and 01
train_pc = .66;

%% ================== Insurance Dataset =====================
[data,txt,raw] = xlsread('../data/insurance.xls','data');
y = strcmp(txt(2:end,31),'Yes')+1; % 1 and 2
X = [data(, 1:7),data(, 9:end)]; % only numeric fields
X = normalize(X); % binary fields are not affected from min-max normalization
[m, n] = size(X);
% Stratified sampling, 2 strata, here the number of buy_insurance = 0 is
% equal to buy_insurance = 1 so simple take m/2, can make it better
% dependent on percentage of categories 0 and 1
train_ind = [randsample(1:sum(y==1),floor(train_pc*sum(y==1))),sum(y==1)+ ...
             randsample(1:sum(y==2),floor(train_pc*sum(y==2)))];

yTrain = y(ismember(1:m,train_ind),:);
yTest = y(~ismember(1:m,train_ind),:);
XTrain = X(ismember(1:m,train_ind),:);
XTest = X(~ismember(1:m,train_ind),:);

lambda = 0.05;
epsilon = 0.1;
Theta1 = rand(hidden_num,1+input_num)*2*epsilon-epsilon; % random beween -epsilon and epsilon
Theta2 = rand(label_num,1+hidden_num)*2*epsilon-epsilon; % random beween -epsilon and epsilon
theta = [Theta1(:);Theta2(:)];

% options = optimset('UseParallel','always','Display','iter','Algorithm','lm-line-search', ...
%                    'GradObj','on','MaxIter',50);
% Algorithm: must be 'active-set', 'trust-region-reflective', 'interior-point',
% 'interior-point-convex', 'interior-point-legacy','levenberg-marquardt',
% 'trust-region-dogleg', 'sqp', or 'simplex'.
options = optimset('Display','iter','GradObj','on','MaxIter',50);
costFunction = @(p) computeCost(p,input_num,hidden_num,label_num,XTrain,yTrain,lambda);
[theta,cost] = fminunc(costFunction,theta,options);

Theta1 = reshape(theta(1:hidden_num*(input_num+1)),hidden_num,(input_num+1));
Theta2 = reshape(theta((1+(hidden_num*(input_num+1))):end),label_num,(hidden_num+1));

predTrain = predict(Theta1,Theta2,XTrain);
fprintf('\nTraining Set Accuracy: %f\n',mean(double(predTrain == yTrain))*100);

predTest = predict(Theta1,Theta2,XTest);
fprintf('\nTest Set Accuracy: %f\n',mean(double(predTest == yTest))*100);