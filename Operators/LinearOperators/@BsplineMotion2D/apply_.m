function y = apply_(bm, x, ~)

if nargout > 0
    if bm.isAdjoint
        y = motion2node2D(x, bm.coef, bm.spacing, bm.sizeNode);
    else
        y = node2motion2D(x, bm.coef, bm.spacing);
    end
end