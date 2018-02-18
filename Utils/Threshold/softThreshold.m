function z = softThreshold(x, lambda)
%softThreshold   Soft Thresholding
%   Z = softThreshold(X,LAMBDA) solves the following problem
%
%      argmin_Z   1/2*||Z-X||^2 + LAMBDA*||X||_1
%
%   where LAMBDA is a positive number.
%
%   See also GST

%   Reference:
%   [1]Combettes, P. L., & Pesquet, J. C. (2011). Proximal splitting 
%   methods in signal processing. Heinz H Bauschke, 49, p¨¢gs. 185-212.
%
%   Copyright 2018 Junshen Xu

absx = abs(x);
z = (absx > lambda) .* (sign(x) .* (absx - lambda));