function [pca,w,k]=pca(data,para)
    [n,d]=size(data);
    covm=cov(data);
    [E,D]=eig(covm); % can also use pca functions in Matlab for principal components
    [val,loc]=sort(diag(D),'descend');
    if para>=1
        k=para;
    else
        k=sum((cumsum(val)/sum(val))<=para);
        if k==0 k=1; end;
    end
    E=E(:,loc);
    w=E(:,1:k);
    length=sqrt(sum(w.^2));
    w=w./(ones(d,1)*length);
    pca= data*w; 
    % pca=(data - repmat(mean(data),n,1))*w; % remove mean before projection

