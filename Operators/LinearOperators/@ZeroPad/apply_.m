function y = apply_(zp, x, ~)

if nargout > 0
    if zp.isAdjoint
        y = cropc(x, zp.sizeCenter);
    else
        y = zpadc(x, zp.sizeFull);
    end
end