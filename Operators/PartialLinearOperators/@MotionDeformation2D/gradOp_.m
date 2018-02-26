function [dM, dI] = gradOp_(op, preGrad)

if op.inList{1}.isConstant
    dM = [];
else
    dM = op.cache{1} .* preGrad;
end

if op.inList{2}.isConstant
    dI = [];
else
    dM = linearInterp2D_mex(preGrad, op.cahce{2}(:,:,1), op.cahce{2}(:,:,2), 1); 
end

end

