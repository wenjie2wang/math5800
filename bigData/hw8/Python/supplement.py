# import modules needed
import numpy as np


# k-means function
def km(X, K, max_iters):
    m, n = X.shape
    centroids = np.random.rand(K, n)
    idx = np.zeros((m, 1))
    idx = idx.astype(int)
    old_idx = np.zeros((m, 1))
    old_idx = old_idx.astype(int)

    for j in range(max_iters):
        change = False
        for i in range(m):
            foo = np.sum((np.tile(X[i, :], (K, 1)) - centroids)**2, axis = 1)
            idx[i] = int(np.argmin(foo))
            if (idx[i] != old_idx[i]) and (not change):
                change = True
        for k in range(K):
            k = np.array(k)
            index = np.squeeze(idx == k)
            centroids[k,:] = np.mean(np.squeeze(X[np.where(index), :]), axis = 0)

        if not change:
            break

        old_idx = idx

    return idx

    
def costFun(param, Y, r, n_lenders, n_loans, n_features, lamba):
    # Extract X and Theta from param vector
    X = param[0:(n_loans * n_features)]
    Theta = param[(n_loans * n_features):len(param)]
    X = X.reshape(n_loans, n_features, order = "F")
    Theta = Theta.reshape(n_lenders, n_features, order = "F")
    
    # Cost
    predictions = np.dot(X, Theta.T)
    errors = np.multiply(predictions - Y, r) 
    J = (1/2)*np.sum(errors**2)

    # Regularized cost function to penalize overfitting
    reg_X = (lamba/2) * np.sum(X**2)
    reg_Theta = (lamba/2) * np.sum(Theta**2)
    J = J + reg_Theta + reg_X
    
    return J

def cost_grad(param, Y, r, n_lenders, n_loans, n_features, lamba):    
    # Extract X and Theta from param vector
    X = param[0:(n_loans * n_features)]
    Theta = param[(n_loans * n_features):len(param)]
    X = X.reshape(n_loans, n_features, order = "F")
    Theta = Theta.reshape(n_lenders, n_features, order = "F")
    predictions = np.dot(X, Theta.T)
    errors = np.multiply(predictions - Y, r) 
    
    # Gradients    
    X_grad = np.dot(errors, Theta) # error is  nm x nu,and Theta is nu x n,X_grad is nm x n
    Theta_grad = np.dot(errors.T, X) # error' is  nu x nm,X is nm x n,so Theta_grad is nu x n
 
    # Add regularization terms to gradients
    X_grad = X_grad + lamba * X
    Theta_grad = Theta_grad + lamba * Theta

    grad = np.concatenate((X_grad.reshape(n_loans * n_features, 1, order = "F"), \
                           Theta_grad.reshape(n_lenders * n_features, 1, order = "F")))
    grad = np.squeeze(grad)
    return grad
    
def optimizeCost(param, Y, r, n_lenders, n_loans, n_features, lamba, step, maxrun):
    cost_range = np.zeros((maxrun, 1))
    for iter in range(maxrun):
        grad = cost_grad(param, Y, r, n_lenders, n_loans, n_features, lamba)
        J = costFun(param, Y, r, n_lenders, n_loans, n_features, lamba)
        param = param - step * grad
        cost_range[iter] = J

    return param
        
        
    
        
        
        
        
        
        