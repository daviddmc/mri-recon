function y = apply_(op, M, I, isCache)

if isCache
    [gradx, grady] = gradient(I);
    if nargout > 0
        interpRes = linearInterp2D_mex(cat(3, I, gradx, grady), M(:,:,1), M(:,:,2));
        op.cache{1} = interpRes(:,:,2:3);
        y = interpRes(:,:,1);
    else
        interpRes = linearInterp2D_mex(cat(3, gradx, grady), M(:,:,1), M(:,:,2));
        op.cache{1} = interpRes;
    end
    
    if ~op.inList{2}.isConstant
        op.cache{2} = M;
    end
else
    y = linearInterp2D_mex(I, M(:,:,1), M(:,:,2));
end


end