function Xmap = mapping(X,degree)
[m,n] = size(X); % m is number of variables
power = selectk(0:degree,n);
ind = (sum(power,2)<=degree);
power = power(ind,:);
p = size(power,1); % number of  polynomial terms
Xmap = ones(m,1);
for i = 1:p
    aterm = ones(m,1);
    for j = 1:n
        aterm = aterm .* X(:,j).^power(i,j);    
    end
    Xmap(:,end+1) = aterm;
end
