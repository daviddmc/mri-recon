function y = apply_(h,x,~)
if nargout > 0
    if h.isAdjoint
        x = reshape(x, h.sizeOut);
        y = row2im(x, h.sizeIn(1:2), h.sizeKernel, 0);
        y = reshape(y, h.sizeIn);
    else
        y = im2row(x, h.sizeKernel); 
        y = reshape(y, size(y, 1), []);
    end
end
    
    