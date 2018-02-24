function y = apply_(op, M, I, isCache)

if isCache
    [gradx, grady] = gradient(I);
    if nargout > 0
        interpRes = mirt2D_mexinterp(cat(3, I, gradx, grady), M(:,:,1), M(:,:,2));
        op.cache = interpRes(:,:,2:3);
        y = interpRes(:,:,1);
    else
        interpRes = mirt2D_mexinterp(cat(3, gradx, grady), M(:,:,1), M(:,:,2));
        op.cache = interpRes;
    end
else
    y = mirt2D_mexinterp(I, M(:,:,1), M(:,:,2));
end


end