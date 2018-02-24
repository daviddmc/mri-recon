function [gA, gB] = gradOp_(op, preGrad)

if op.inList{1}.isConstant
    gA = [];
else
    if op.inList{2}.isConstant
        gA = op.inList{2}.cache * preGrad';
    else
        gA = op.cache{2} * preGrad';
    end
end

if op.inList{2}.isConstant
    gB = [];
else
    if op.inList{1}.isConstant
        gB = op.inList{1}.cache * preGrad;
    else
        gB = op.cache{1} * preGrad;
    end
end

end

