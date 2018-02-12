function [gA, gB] = gradOp_(op, preGrad)

if op.inputList{1}.isConstant
    gA = [];
else
    if op.inputList{2}.isConstant
        gA = op.inputList{2}.cache * preGrad';
    else
        gA = op.cache{2} * preGrad';
    end
end

if op.inputList{2}.isConstant
    gB = [];
else
    if op.inputList{1}.isConstant
        gB = op.inputList{1}.cache * preGrad;
    else
        gB = op.cache{1} * preGrad;
    end
end

end

