function [cost,grad] = computeCost(theta,X,y,lambda)
    m = length(y); % number of training examples
    cost = 0;
    grad = zeros(size(theta));
    if nargin < 4
        lambda = 0; % this lambda=0 make the reularized term to go away, when a value is passed it is the step
    end
    z = X*theta; % z is m x d
    h = sigmoid(z); % same as z
    grad = (1/m * (h-y)' * X) + lambda * [0;theta(2:end)]'/m; % grad is 1 x d, theta(1) - meaning theta_0 should not be regularized
	cost =  1/(m) * sum(-y .* log(h) - (1-y) .* log(1-h)) + lambda/m/2*sum(theta(2:end).^2); % theta(1) - meaning theta_0 should not be regularized
end


