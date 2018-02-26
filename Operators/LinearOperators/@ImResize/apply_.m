function y = apply_( ir, x, ~)


if nargout>0
    if ir.isAdjoint
        error(' ');
    else
        y = imresize(x, ir.siz);
    end
end