function y = eval_( ss, x, isCache)

if isCache
    ss.cache = x;
end

if nargout > 0
    ndimX = ndims(x);
    nLast = size(x, ndimX);
    prefix = cell(1, ndimX - 1);
    prefix(:) = {':'};
    y = 0;

    for ii = 1 : nLast
        if isempty(prefix)
            y = y + ss.funList{ii}.eval(x(ii));
        else
            y = y + ss.funList{ii}.eval(x(prefix{:}, ii));
        end
    end
end


end

