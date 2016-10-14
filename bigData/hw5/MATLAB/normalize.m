function [Xnorm] = normalize(X)
[m,n] = size(X);
mu = mean(X,1);
sigma = std(X,0,1);
Xnorm = (X-repmat(mu,m,1))./repmat(sigma,m,1);
end
