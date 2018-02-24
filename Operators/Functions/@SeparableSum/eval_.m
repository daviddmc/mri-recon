function y = eval_( ss, x, isCache)

ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};
y = 0;

for ii = 1 : nLast
    if isempty(prefix)
        y = y + ss.inList{ii+1}.eval(x(ii));
    else
        y = y + ss.inList{ii+1}.eval(x(prefix{:}, ii));
    end
end

if isCache
    ss.cache = x;
end

end

