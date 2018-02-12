function y = apply_(bm, x, ~)

if nargout > 0
    if bm.isAdjoint
        if bm.is3D
            %motion2node3D
        else
            y = motion2node2D(x, bm.coef, bm.spacing, bm.sizeNode);
        end
    else
        if bm.is3D
            %node2motion3D
        else
            y = node2motion2D(x, bm.coef, bm.spacing);
        end
    end
end