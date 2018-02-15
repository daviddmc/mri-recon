function [g1, g2] = gradOp_(sad, prevGrad)

    if sad.inputList{1}.isConstant
        g1 = [];
    else
        g1 = prevGrad * sign(sad.cache);
    end
    
    if sad.inputList{2}.isConstant
        g2 = [];
    else
        g2 = -prev_grad * sign(sad.cache);
    end
    