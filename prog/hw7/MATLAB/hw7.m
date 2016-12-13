%% =====================
clear all; close all; clc;
S0 = 60;
K1 = 55;
K2 = 65;
T = 2;
r = 0.1;
sigma = 0.4;
M = 4;

%% =====================
% blsprice for verification
[calls,puts] = blsprice(S0,[K1,K2],r,T,sigma);

%% =====================
% Bull spread: using calls
[C,D] = BullspreadEu(S0,K1, K2,r,T,sigma,M,1) % 1 using calls; 0 using puts
value = C - D % for calls
% Bull spread: using puts
[C,D] = BullspreadEu(S0,K1, K2,r,T,sigma,M,0) % 1 using calls; 0 using puts
value = D - C % for puts

%% =====================
% essentially, the pricing method for Bear spread is the same as that for
% Bull spread
% Bear spread: using calls
[C,D] = BearspreadEu(S0,K1, K2,r,T,sigma,M,1); % 1 using calls; 0 using puts
value = -(C - D) % for calls
% Bear spread: using puts
[C,D] = BearspreadEu(S0,K1, K2,r,T,sigma,M,0); % 1 using calls; 0 using puts
value = -(D - C) % for puts
