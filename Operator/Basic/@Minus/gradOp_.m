function [ga, gb] = gradOp_(op, preGrad)
if op.inputList{1}.isConstant
    ga = [];
else
    ga = preGrad;
end

if op.inputList{2}.isConstant
    gb = [];
else
    gb = -preGrad;
end

end

