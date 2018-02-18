%function z = schattenProx(z, lambda, p)
function z = GSVT(z, lambda, p)
%GSVT   Generalized Singular Value Thresholding
%   Z = GSVT(X,LAMBDA) solves the following problem
%
%      argmin_Z   1/2*||Z-X||^2 + GAMMA*R(X)
%
%   where GAMMA and P are positive numbers and 
%
%      R(X) = ||sigma(X)||_P^P / P
%
%   See also SVT, GST

%   Reference:
%   [1]Lu, C., Zhu, C., Xu, C., Yan, S., & Lin, Z. (2014). Generalized 
%   singular value thresholding. Computer Science.
%
%   Copyright 2018 Junshen Xu

if p == 1
    z = SVT(z, lambda);
else
    [u, s, v] = svd(z, 'econ');
    s = GST(diag(s), lambda, p);
    r = find(s > eps, 1, 'last');
    if isempty(r)
        z = z * 0;
    else
        z = u(:, 1:r) * bsxfun(@times, s(1:r), v(:, 1:r)');
    end    
end
