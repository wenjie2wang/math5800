function g = sigmoid(z)
    g = ones(size(z))./(1+exp(-z));
end
