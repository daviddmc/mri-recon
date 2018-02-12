function f = eval_(ssd, x, y, isCache)
    
    dif = x - y;
    
    if isCache
        ssd.cache = dif;
    end
    
    if nargout > 0
        f = 0.5 * (dif(:)' * dif(:));
    end
    
end
    
    