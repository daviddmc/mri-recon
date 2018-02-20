function X = ifftc(x, dim)
%IFFTC   centered ifft
%   IFFTC(X) is the N-dimensional inverse discrete Fourier tranform of 
%   N-D array X, with origin shifted to the center of the array. The result 
%   will be normed so that IFFTC is an unitary operator.
%
%   IFFTC(X, DIM) applyies the IFFTC operation across dimension DIM.
%
%   See also fftc

%   Copyright 2018 Junshen Xu

if nargin == 1
    dim = 1 : ndims(x);
end

sizeX = size(x);
ftr = sqrt(prod(sizeX(dim)));

X = x;
for ii = dim
    X = ifftshift(X,ii);
end
for ii = dim
    X = ifft(X,[],ii);
end
for ii = dim
    X = fftshift(X,ii);
end

X = ftr * X;

end

