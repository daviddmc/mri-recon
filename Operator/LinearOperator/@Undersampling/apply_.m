function y = apply_(m,x,~)
if nargout > 0
    if m.isAdjoint
        if m.isReduced
            y = zeros(m.sizeMask);
            y(m.idx) = x;
        else
            y = bsxfun(@times, x, m.mask);
        end
    else
        if m.isReduced
            y = x(m.idx);
        else
            y = bsxfun(@times, x, m.mask);
        end
    end
end
    
    