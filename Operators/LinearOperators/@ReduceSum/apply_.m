function y = apply_(s, x, ~)

if nargout > 0
    if s.isAdjoint
        d = ones(1, ndims(x));
        d(s.dim) = s.len;
        if s.isNormalized
            y = repmat(x, d) / sqrt(s.len);
        else
            y = repmat(x, d);
        end
    else
        if s.isNormalized
            y = sum(x, s.dim) / sqrt(s.len);
        else
            y = sum(x, s.dim);
        end
    end
end
end
    
    