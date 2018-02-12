function [dM, dI] = gradOp_(op, preGrad)

if op.inputList{1}.isConstant
    dM = [];
else
    dM = op.cache .* preGrad;
end

if op.inputList{2}.isConstant
    dI = [];
else
    % TODO
end

end

