function y = pinv_(s, x)

if s.isAdjoint
    if s.isNormalized
        y = sum(x, s.dim) / sqrt(s.len);
    else
        y = sum(x, s.dim) / s.len;
    end
else
    d = ones(1, ndims(x));
    d(s.dim) = s.len;
    if s.isNormalized
        y = repmat(x / sqrt(s.len), d) ;
    else
        y = repmat(x / s.len, d) ;
    end

end

