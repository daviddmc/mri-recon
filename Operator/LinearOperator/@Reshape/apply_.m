function y = apply_( rs, x, ~)

if nargout>0
    if rs.isAdjoint
        y = reshape(x, rs.sizeIn);
    else
        y = reshape(x, rs.sizeOut);
    end
end

