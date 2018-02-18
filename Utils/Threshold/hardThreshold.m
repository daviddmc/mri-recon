function x = hardThreshold(x, lambda)
%hardThreshold   hard Thresholding
%   Z = hardThreshold(X,LAMBDA) performs hard thresholding on X with LAMBDA
%   as threshold.
%
%   See also softThreshold

%   Copyright 2018 Junshen Xu

x(abs(x) < lambda) = 0;