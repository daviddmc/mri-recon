function [AtA,A,kernel] = dat2AtA(data, kSize)

% [AtA,A,kernel] = dat2AtA(data, kSize)
%
% Function computes the calibration matrix from calibration data. 
%
% (c) Michael Lustig 2013

[sx,sy,nc] = size(data);
tmp = im2row(data,kSize); 
[tsx,tsy,tsz] = size(tmp);
A = reshape(tmp,tsx,tsy*tsz);
AtA = A'*A;

