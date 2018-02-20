function y = RSS(x, dim)
%RSS   Root sum squared 
%   For N-D array X, RSS(X) calculates the root sum squared value along 
%   the last (non-singleton) dimension.
%
%   Y = RSS(X, DIM) operates along the dimension DIM.

%   Copyright 2018 Junshen Xu

if nargin == 1
    dim = ndims(x);
end

y = sqrt(sum(abs(x).^2, dim));

end

