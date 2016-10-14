function [theta,cost_range] = optimizeCost(X,y,theta,step,maxrun)
    m = length(y);
    cost_range = zeros(maxrun,1);

    for iter = 1:maxrun
        h = X*theta;
        grad = 1/m * (h-y)' * X; % grad is 1 x d
        theta = theta - step * grad';
        diff = (h-y);
        cost_range(iter) = 1/2/m*(diff'*diff);
    end
end
