function [param,cost_range] = optimizeCost(param,Y,r,n_lenders,n_loans,n_features,lambda,step,maxrun)
    cost_range = zeros(maxrun,1);

    for iter = 1:maxrun
        [J,grad] = costFunction(param,Y,r,n_lenders,n_loans,n_features,lambda);
        param = param - step * grad; % Gradient descent for both X and Theta
        cost_range(iter) = J;
    end
end