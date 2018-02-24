function y = apply_( bd, x, ~)

ndimX = ndims(x);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};
y = zeros(size(x));

if isempty(bd.idx)
    nLast = size(x, ndimX);
    for ii = 1 : nLast
        idx{ii} = ii;
    end
else
    idx = bd.idx;
end

if bd.isAdjoint
    for ii = 1 : length(idx)
        y(prefix{:}, idx{ii}) = bd.inList{ii+1}.adjoint(x(prefix{:}, idx{ii}));
    end
else
    for ii = 1 : length(idx)
        y(prefix{:}, idx{ii}) = bd.inList{ii+1}.apply(x(prefix{:}, idx{ii}));
    end
end


