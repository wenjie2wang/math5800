function g = gradient(z)
    g = [ones(size(z,1),1) sigmoid(z)].*[ones(size(z,1),1) (1-sigmoid(z))];
end
