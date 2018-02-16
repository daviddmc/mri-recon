function [data, nc] = CCSVD( data, tol, cdim)

ndim = ndims(data);
if nargin < 3
    cdim = ndim;
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

