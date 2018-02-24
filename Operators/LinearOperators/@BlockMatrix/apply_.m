function y = apply_( bm, x, ~)

if bm.isRow
    if bm.isAdjoint
        ndimX = ndims(x);
        prefix = cell(1, ndimX - 1);
        prefix(:) = {':'};

        if isempty(bm.idx)
            nLast = size(x, ndimX);
            for ii = 1 : nLast
                idx{ii} = ii;
            end
        else
            idx = bm.idx;
        end

        y = bm.inList{2}.adjoint(x(prefix{:}, idx{1}));
        for ii = 2 : length(idx)
            y = y + bm.inList{ii+1}.adjoint(x(prefix{:}, idx{ii}));
        end
    else
        for ii = 1 : length(bm.inList)-1
            y{ii} = bm.inList{ii+1}.apply(x);
        end
        y = cat(bm.dim, y{:});
    end
else

    if bm.isAdjoint
        for ii = 1 : length(bm.inList)-1
            y{ii} = bm.inList{ii+1}.adjoint(x);
        end
        y = cat(bm.dim, y{:});
    else
        ndimX = ndims(x);
        prefix = cell(1, ndimX - 1);
        prefix(:) = {':'};

        if isempty(bm.idx)
            nLast = size(x, ndimX);
            for ii = 1 : nLast
                idx{ii} = ii;
            end
        else
            idx = bm.idx;
        end

        y = bm.inList{2}.apply(x(prefix{:}, idx{1}));
        for ii = 2 : length(idx)
            y = y + bm.inList{ii+1}.apply(x(prefix{:}, idx{ii}));
        end
    end
end


