function [g1, g2] = gradOp_(sad, prevGrad)

    if sad.inList{1}.isConstant
        g1 = [];
    else
        g1 = prevGrad * sign(sad.cache);
    end
    
    if sad.inList{2}.isConstant
        g2 = [];
    else
        g2 = -prev_grad * sign(sad.cache);
    end
    