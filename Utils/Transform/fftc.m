function X = fftc(x, dim)
%FFTC   centered fft
%   FFTC(X) is the N-dimensional discrete Fourier tranform of N-D array X,
%   with origin shifted to the center of the array. The result will be
%   normed so that FFTC is an unitary operator.
%
%   FFTC(X, DIM) applyies the FFTC operation across dimension DIM.
%
%   See also ifftc

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
    X = fft(X,[],ii);
end
for ii = dim
    X = fftshift(X,ii);
end

X = 1/ftr * X;

end

