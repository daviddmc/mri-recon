function [ga, gb] = gradOp_(op, preGrad)
if op.inList{1}.isConstant
    ga = [];
else
    ga = preGrad;
end

if op.inList{2}.isConstant
    gb = [];
else
    gb = -preGrad;
end

end

