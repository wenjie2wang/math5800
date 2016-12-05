function cost = computeCost(X,y,theta)
    m = length(y);
    cost = 0;
    h = X*theta;
    diff = (h-y);
    cost = 1/2/m*(diff'*diff);
end
