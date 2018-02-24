function f = eval_(sad, x, y, isCache)
    
    dif = x - y;
    
    if isCache
        sad.cache = dif;
    end
    
    if nargout > 0
        f = sum(abs(dif));
    end
    
end
    
    