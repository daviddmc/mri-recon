function y = pinv_(h, x)

if h.isAdjoint
    W = row2im([], h.sizeIn, h.sizeKernel);
    y = x ./ W;
    y = im2row(y, h.sizeKernel); 
    y = reshape(y, size(y, 1), []);
else
    x = reshape(x, h.sizeOut);
    y = row2im(x, h.sizeIn(1:2), h.sizeKernel, true);
    y = reshape(y, h.sizeIn);
end

end

