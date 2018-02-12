function f = eval_(ssd,x, isCache)
    
    if isCache
        ssd.cache = x;
    end
    
    if nargout > 0
        f = 0.5 * (x(:)' * x(:));
    end
    
end
    
    