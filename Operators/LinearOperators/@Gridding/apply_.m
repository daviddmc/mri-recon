function y = apply_(m,x,~)
if nargout > 0
    if m.isAdjoint
        y = reshape(m.A' * x, [m.im_size, size(x,2)]);
    else
        siz = size(x);
        d = length(m.im_size);
        y = m.A * reshape(x, [prod(siz(1:d)), prod(siz(d+1:end))]);
    end
end
    
    