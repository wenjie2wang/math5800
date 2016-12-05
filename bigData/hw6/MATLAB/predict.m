function pred = predict(Theta1,Theta2,X)
    m = size(X,1);
    h1 = sigmoid([ones(m, 1) X]*Theta1');
    h2 = sigmoid([ones(m, 1) h1]*Theta2');
    [dummy,pred] = max(h2,[],2);
end
