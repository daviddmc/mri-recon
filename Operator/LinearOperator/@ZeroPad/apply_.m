function y = apply_(zp, x, ~)

if nargout > 0
    if zp.isAdjoint
        y = cropCenter(x, zp.sizeCenter);
    else
        y = padCenter(x, zp.sizeFull);
    end
end