function y = selectk(v,k)
m = length(v);
X = cell(1,k);
[X{:}] = ndgrid(v);
X = X(end:-1:1);
y = cat(k+1,X{:});
y = reshape(y,[m^k,k]);
