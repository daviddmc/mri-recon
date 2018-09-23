function y = apply_(m,x,~)
if nargout > 0
    if m.isAdjoint
        y = reshape(m.A' * x, m.im_size);
    else
        y = m.A * x(:);
    end
end
    
    