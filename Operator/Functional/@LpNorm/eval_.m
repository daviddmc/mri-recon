function y = eval_(lp, x, isCache)

    if isCache
        lp.cache = x;
    end
    
    y = sum(abs(x(:)) .^ lp.p);
    y = y / lp.p;

end