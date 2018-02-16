function y = eval_(l12norm, x, isCache)

    y = sqrt(sum(abs(x).^2, l12norm.dim2));
    if isCache
        l12norm.cache = x ./ (y + eps);
    end
    y = sum(y(:));
    
end