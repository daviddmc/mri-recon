function [data, nc] = CCSVD( data, tol, cdim)
%CCSVD   coil compression using singular value decomposition
%   Y = CCSVD(X) performs coil compression on X using SVD.
%
%   Y = CCSVD(X, TOL) specifies the tolerance of singular value. The
%   default is 0.05 (using the largest 5% singular value);
%
%   Y = CCSVD(X, TOL, DIM) specifies the dimension of coil. The default is
%   the last dimension of X.
%
%   [Y, N] = CCSVD(X,...) also returns the number of virtual coils of Y, 
%   i.e. N = ndims(Y, DIM).

%   This code is modified from Michael Lustig's SPIRiT V0.3 library
%   https://people.eecs.berkeley.edu/~mlustig/Software.html

%   Copyright 2018 Junshen Xu

ndim = ndims(data);
if nargin < 3 % operate on the last dimension by default
    cdim = ndim;
end

if nargin < 2 || isempty(tol)
    tol = 0.05;
end
    
if cdim ~= ndim
    data = permute(data, [1:cdim-1, cdim+1:ndim, cdim]);
end

sizeD = size(data);
data = reshape(data, [], size(data, ndim));
[~, S, V] = svd(data, 'econ');
nc = find(diag(S)/S(1) > tol, 1, 'last');
sizeD(end) = nc;
data = reshape(data * V(:, 1:nc), sizeD);

if cdim~=ndim
    data = ipermute(data, [1:cdim-1, cdim+1:ndim, cdim]);
end

end

