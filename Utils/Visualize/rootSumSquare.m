function sos = rootSumSquare(x ,dim, p)

if nargin < 2
    dim = ndims(x);
end

if nargin < 3
    p = 2;
end

sos = sum(abs(x.^p),dim) .^ (1/p);
