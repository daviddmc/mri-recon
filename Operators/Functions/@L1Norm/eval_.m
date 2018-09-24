function y = eval_(l1norm, x, isCache)


    y = sum(abs(x(:)));
    if isCache
        %l1norm.cache = sign(x);
        l1norm.cache = x;
    end

end