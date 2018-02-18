function z = SVT(z, lambda, isCheck)
%SVT   Singular Value Thresholding
%   Z = SVT(X,LAMBDA) solves the following problem
%
%      argmin_Z   1/2*||Z-X||^2 + GAMMA*||X||_nuc
%
%   where GAMMA is a positive number.
%   
%   Z = SVT(X,LAMBDA,P,ISCHECK) specifies the check flag. When ISCHECK = 
%   True, SVT will check the upper bound of the singular value before
%   performing SVD.
%
%   See also softThreshold, GSVT

%   Reference:
%   [1]Lu, C., Zhu, C., Xu, C., Yan, S., & Lin, Z. (2014). Generalized 
%   singular value thresholding. Computer Science.
%
%   Copyright 2018 Junshen Xu

if isvector(z)
    t = norm(z(:));
    z = softThreshold(t, lambda) * z / (t + eps);
    return;
end

if nargin > 2 && isCheck
    if ( size(z,1) > size(z,2) )
        zz = z' * z;
    else
        zz = z * z';
    end
    
    if  max( sum( abs( zz ), 1 ) ) < lambda^2
        z = z * 0;
        return
    end
end

[u, s, v] = svd(z, 'econ');
s = softThreshold(diag(s), lambda);
r = find(s > eps, 1, 'last');
if isempty(r)
    z = z * 0;
else
    z = u(:, 1:r) * bsxfun(@times, s(1:r), v(:, 1:r)');
end
