function y = eval_(tv, x, ~)

if nargout > 0
    g = tv.G.apply(x);

    if strcmp(tv.type,'isotropic')
        g = abs(g).^2;
        gnorm = sqrt(sum(g, ndims(g)));
        y = sum(gnorm(:));
    else
        g = tv.G.apply(x);
        y = sum(abs(g(:)));
    end
end
