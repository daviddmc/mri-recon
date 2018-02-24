function A = calibmat(data, ksize, AtA)
%CALIBMAT   calibration matrix
%   calibmat(DATA, KSIZE, ATA) computes the calibration matrix from DATA
%   using kernel size KSIZE. When ATA is true, the returned result is A'*A 
%   where A is the calibration matrix. The default of ATA is true.

%   Copyright 2018 Junshen Xu

if nargin < 3 || isempty(AtA)
    AtA = true;
end

A = im2row(data, ksize);
A = reshape(A, size(A, 1), []);

if AtA
    A = A'*A;
end

