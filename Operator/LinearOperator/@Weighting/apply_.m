function y = apply_(m,x,~)
if nargout > 0
    if m.isAdjoint
        y = conj(m.w) .* x;
    else
        y = m.w .* x;
    end
end
    
    